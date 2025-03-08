enum DeviceType: char (inline char v) {
	INTERGRATED = 10,
	DISCRETE = 30,
}
struct Engine {
	DeviceType render_device;
	DeviceType compute_device;
}
fn void! testC3Enum() @test {
	Engine e = {
		.render_device = DeviceType.INTERGRATED,
		.compute_device = DeviceType.DISCRETE,
	};
	void* data = &e;
	char[] buffer = data[:Engine.sizeof];
	assert(buffer[0] == DeviceType.INTERGRATED);
	assert(buffer[1] == DeviceType.DISCRETE);
}
