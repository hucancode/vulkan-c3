module mj;
import std::math::quaternion;
import std::sort;

struct Animation {
    NodeHandle node;
    AnimationChannel channels;
}
def AnimationTrack = Animation[];

struct AnimationChannel {
    PositionKeyframe[] positions;
    RotationKeyframe[] rotations;
    ScaleKeyframe[] scales;
}

struct PositionKeyframe {
    float time;
    float[<3>] value;
}

struct RotationKeyframe {
    float time;
    Quaternion value;
}

struct ScaleKeyframe {
    float time;
    float[<3>] value;
}

fn float[<3>] sample_position(PositionKeyframe[] keyframes, float t) {
    if (keyframes.len == 0) return { 0, 0, 0 };
    if (t <= keyframes[0].time) return keyframes[0].value;
    if (t >= keyframes[keyframes.len - 1].time) return keyframes[keyframes.len - 1].value;
    usz index = binarysearch(keyframes, t, fn int(PositionKeyframe kf, float time) {
        if (kf.time < time) return -1;
        if (kf.time > time) return 1;
        return 0;
    });
    usz next_idx = index;
    usz prev_idx = next_idx - 1;
    float prev_time = keyframes[prev_idx].time;
    float next_time = keyframes[next_idx].time;
    float alpha = (t - prev_time) / (next_time - prev_time);
    float[<3>] prev_pos = keyframes[prev_idx].value;
    float[<3>] next_pos = keyframes[next_idx].value;
    return alpha * prev_pos + (1 - alpha) * next_pos;
}

fn Quaternion sample_rotation(RotationKeyframe[] keyframes, float t) {
    if (keyframes.len == 0) return quaternion::identity();
    if (t <= keyframes[0].time) return keyframes[0].value;
    if (t >= keyframes[keyframes.len - 1].time) return keyframes[keyframes.len - 1].value;
    usz index = binarysearch(keyframes, t, fn int(RotationKeyframe kf, float time) {
        if (kf.time < time) return -1;
        if (kf.time > time) return 1;
        return 0;
    });
    usz next_idx = index;
    usz prev_idx = next_idx - 1;
    float prev_time = keyframes[prev_idx].time;
    float next_time = keyframes[next_idx].time;
    float alpha = (t - prev_time) / (next_time - prev_time);
    Quaternion q1 = keyframes[prev_idx].value;
    Quaternion q2 = keyframes[next_idx].value;
    return quaternion::slerp(q1, q2, alpha);
}

fn float[<3>] sample_scale(ScaleKeyframe[] keyframes, float t) {
    if (keyframes.len == 0) return { 1, 1, 1 };
    if (t <= keyframes[0].time) return keyframes[0].value;
    if (t >= keyframes[keyframes.len - 1].time) return keyframes[keyframes.len - 1].value;
    usz index = binarysearch(keyframes, t, fn int(ScaleKeyframe kf, float time) {
        if (kf.time < time) return -1;
        if (kf.time > time) return 1;
        return 0;
    });
    usz next_idx = index;
    usz prev_idx = next_idx - 1;
    float prev_time = keyframes[prev_idx].time;
    float next_time = keyframes[next_idx].time;
    float alpha = (t - prev_time) / (next_time - prev_time);
    float[<3>] prev_scale = keyframes[prev_idx].value;
    float[<3>] next_scale = keyframes[next_idx].value;
    return alpha * prev_scale + (1 - alpha) * next_scale;
}
