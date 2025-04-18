module hellovk;
import std::math::matrix;
import std::math;
import std::math::vector;

struct UniformBuffer @align(16) {
	Matrix4x4{float} projection;
	Matrix4x4{float} view;
	Matrix4x4{float} model;
	float time;
}
