module hellovk;
import std::math::matrix;
import std::math;
import std::math::vector;

struct UniformBufferObject @align(16) {
	Matrix4f projection;
	Matrix4f view;
	Matrix4f model;
	float time;
}
