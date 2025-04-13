const vips = @This();
extern fn vips_image_new_from_file(p_name: [*:0]const u8, ...) ?*vips.Image;
pub const newFromFile = vips_image_new_from_file;
