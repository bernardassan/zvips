const std = @import("std");

fn StructToFlatTuple(comptime T: type, value: T) type {
    comptime {
        const fields = std.meta.fields(T);
        var tuple_fields: [fields.len * 2 + 1]std.builtin.Type.StructField = undefined;

        var index, var end_index = .{ 0, 0 };
        // can't use for (fields,0..) |field, index| because we skip some fields
        for (fields) |field| {
            // skip null value fields
            if (@typeInfo(field.type) == .optional and
                @field(value, field.name) == null) continue;
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
                    []const u8
                else if (type_info == .@"struct" and type_info.@"struct".layout == .@"packed")
                    type_info.@"struct".backing_integer.?
                else
                    field.type;
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
}

fn flatTuple(comptime T: type, value: T) StructToFlatTuple(T, value) {
    comptime {
        if (@typeInfo(T) != .@"struct") @compileError("Expected struct type but got " ++ @typeName(T));
        const fields = std.meta.fields(T);
        var tuple: StructToFlatTuple(T, value) = undefined;

        var index, var end_index = .{ 0, 0 };
        for (fields) |field| {
            // skip null value fields
            if (@typeInfo(field.type) == .optional and
                @field(value, field.name) == null) continue;
            const key_index = index * 2;
            const value_index = key_index + 1;
            // increment index
            index += 1;
            end_index = value_index + 1;
            // field name
            @field(tuple, std.fmt.comptimePrint("{}", .{key_index})) = field.name;
            // field vale
            const field_value = blk: {
                const field_value = @field(value, field.name);
                const type_info = @typeInfo(field.type);
                break :blk if (type_info == .@"enum")
                    @tagName(field_value)
                else if (type_info == .@"struct" and type_info.@"struct".layout == .@"packed")
                    @as(type_info.@"struct".backing_integer.?, @bitCast(field_value))
                else
                    field_value;
            };

            @field(tuple, std.fmt.comptimePrint("{}", .{value_index})) = field_value;
        }

        // end varargs with null
        @field(tuple, std.fmt.comptimePrint("{}", .{end_index})) = null;

        return tuple;
    }
}

test flatTuple {
    const Person = struct {
        name: []const u8,
        age: ?u32 = 42,
        gender: enum { male, female },
        wealth: packed struct(u32) { rich: u24, poor: u8 },
        favorite_food: ?[]const u8 = null,
    };

    const person = Person{
        .name = "Alice",
        .gender = .male,
        .wealth = .{ .rich = 7, .poor = 0 },
    };
    const flat_tuple = comptime flatTuple(Person, person);
    try std.testing.expectEqual(.{
        "name",   "Alice",
        "age",    42,
        "gender", "male",
        "wealth", 7, //
        null,
    }, flat_tuple);
}
