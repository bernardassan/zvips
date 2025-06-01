const std = @import("std");

fn StructToFlatTuple(value: anytype) type {
    const T, const active_field = blk: {
        switch (@typeInfo(@TypeOf(value))) {
            .@"union" => {
                const active_tag = std.meta.activeTag(value);
                const T = @FieldType(@TypeOf(value), @tagName(active_tag));
                const active_field = @field(value, @tagName(active_tag));
                break :blk .{ T, active_field };
            },
            else => {
                break :blk .{ @TypeOf(value), value };
            },
        }
    };
    const fields = std.meta.fields(T);
    var tuple_fields: [fields.len * 2 + 1]std.builtin.Type.StructField = undefined;

    var index, var end_index = .{ 0, 0 };
    // can't use for (fields,0..) |field, index| because we skip some fields
    for (fields) |field| {
        // skip null value fields
        if (@typeInfo(field.type) == .optional and
            @field(active_field, field.name) == null) continue;
        const key_index = index * 2;
        const value_index = key_index + 1;
        index += 1;
        end_index = value_index + 1;
        // Field name entry
        tuple_fields[key_index] = .{
            .name = std.fmt.comptimePrint("{}", .{key_index}),
            .type = []const u8,
            .default_value_ptr = null,
            .is_comptime = false,
            .alignment = @alignOf([]const u8),
        };
        const resolved_type = blk: {
            const type_info = @typeInfo(field.type);
            break :blk if (type_info == .@"enum")
                type_info.@"enum".tag_type
            else if (type_info == .@"struct" and type_info.@"struct".layout == .@"packed")
                type_info.@"struct".backing_integer.?
            else if (type_info == .@"union") {
                const active_value = @field(active_field, field.name);
                const TagType = @FieldType(@TypeOf(active_value), @tagName(std.meta.activeTag(active_value)));
                break :blk TagType;
            } else field.type;
        };
        // Field value entry
        tuple_fields[value_index] = .{
            .name = std.fmt.comptimePrint("{}", .{value_index}),
            .type = resolved_type,
            .default_value_ptr = null,
            .is_comptime = false,
            .alignment = @alignOf(resolved_type),
        };
    }
    // null entry
    tuple_fields[end_index] = .{
        .name = std.fmt.comptimePrint("{}", .{end_index}),
        .type = ?*const anyopaque,
        .default_value_ptr = null,
        .is_comptime = false,
        .alignment = @alignOf(?*anyopaque),
    };

    const tuple = @Type(.{ .@"struct" = .{
        .layout = .auto,
        .fields = tuple_fields[0 .. end_index + 1],
        .decls = &.{},
        .is_tuple = true,
    } });
    return tuple;
}

fn flatTuple(value: anytype) StructToFlatTuple(value) {
    const T, const active_field = blk: {
        switch (@typeInfo(@TypeOf(value))) {
            .@"union" => {
                const active_tag = std.meta.activeTag(value);
                const T = @FieldType(@TypeOf(value), @tagName(active_tag));
                const active_field = @field(value, @tagName(active_tag));
                break :blk .{ T, active_field };
            },
            else => {
                break :blk .{ @TypeOf(value), value };
            },
        }
    };
    if (@typeInfo(T) != .@"struct") @compileError("Expected struct type but got " ++ @typeName(T));
    const fields = std.meta.fields(T);
    var tuple: StructToFlatTuple(value) = undefined;
    var index, var end_index = .{ 0, 0 };
    for (fields) |field| {
        // skip null value fields
        if (@typeInfo(field.type) == .optional and
            @field(active_field, field.name) == null) continue;
        const key_index = index * 2;
        const value_index = key_index + 1;
        // increment index
        index += 1;
        end_index = value_index + 1;
        // field name <-> value tuple
        const field_name, const field_value = blk: {
            const field_value = @field(active_field, field.name);
            const type_info = @typeInfo(field.type);
            break :blk if (type_info == .@"enum")
                .{ field.name, @intFromEnum(field_value) }
            else if (type_info == .@"struct" and type_info.@"struct".layout == .@"packed")
                .{ field.name, @as(type_info.@"struct".backing_integer.?, @bitCast(field_value)) }
            else if (type_info == .@"union") {
                const active_field_name = @tagName(std.meta.activeTag(field_value));
                const active_value = @field(field_value, active_field_name);
                break :blk .{ active_field_name, active_value };
            } else .{ field.name, field_value };
        };

        // field name
        @field(tuple, std.fmt.comptimePrint("{}", .{key_index})) = field_name;
        @field(tuple, std.fmt.comptimePrint("{}", .{value_index})) = field_value;
    }

    // end varargs with null
    @field(tuple, std.fmt.comptimePrint("{}", .{end_index})) = null;

    return tuple;
}

test flatTuple {
    comptime {
        const Entity = union(enum) {
            person: struct {
                name: []const u8,
                age: ?u32 = 42,
                gender: enum { male, female },
                wealth: packed struct(u32) { rich: u24, poor: u8 },
                favorite_food: ?[]const u8 = null,
                status: union(enum) { married: []const u8, single: bool },
            },
        };
        const entity: Entity = .{
            .person = .{
                .name = "Alice",
                .gender = .male,
                .wealth = .{
                    .rich = 7,
                    .poor = 0,
                },
                .status = .{
                    .married = "happily",
                },
            },
        };

        const flat_tuple = flatTuple(entity);
        try std.testing.expectEqualDeep(.{
            "name",    "Alice",
            "age",     42,
            "gender",  0,
            "wealth",  7,
            "married", "happily",
            null,
        }, flat_tuple);
    }
    {
        const Person = struct {
            name: []const u8,
            age: ?u32 = 42,
            gender: enum { male, female },
            wealth: packed struct(u32) { rich: u24, poor: u8 },
            favorite_food: ?[]const u8 = null,
            status: union(enum) { married: []const u8, single: bool },
        };
        const person: Person = .{
            .name = "Alice",
            .gender = .male,
            .wealth = .{
                .rich = 7,
                .poor = 0,
            },
            .status = .{
                .married = "happily",
            },
        };
        const flat_tuple = comptime flatTuple(person);
        try std.testing.expectEqualDeep(.{
            "name",    "Alice",
            "age",     42,
            "gender",  0,
            "wealth",  7,
            "married", "happily",
            null,
        }, flat_tuple);
    }
}
