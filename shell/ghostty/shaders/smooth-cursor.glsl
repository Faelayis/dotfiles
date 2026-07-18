const float DURATION = 0.28;

float easeOutCubic(float t) {
    return 1.0 - pow(1.0 - t, 3.0);
}

float sdSweptBox(vec2 point, vec2 start, vec2 end, vec2 halfSize) {
    vec2 segment = end - start;
    float lengthSquared = max(dot(segment, segment), 0.0001);
    float position = clamp(dot(point - start, segment) / lengthSquared, 0.0, 1.0);
    vec2 distanceToBox = abs(point - (start + segment * position)) - halfSize;
    return length(max(distanceToBox, 0.0)) + min(max(distanceToBox.x, distanceToBox.y), 0.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord / iResolution.xy);

    if (iFocus == 0 || iCursorVisible.x == 0.0) {
        return;
    }

    float elapsed = iTime - iTimeCursorChange;
    if (elapsed < 0.0 || elapsed >= DURATION) {
        return;
    }

    vec2 currentSize = iCurrentCursor.zw;
    vec2 previousSize = iPreviousCursor.zw;
    vec2 currentCenter = iCurrentCursor.xy + vec2(currentSize.x, -currentSize.y) * 0.5;
    vec2 previousCenter = iPreviousCursor.xy + vec2(previousSize.x, -previousSize.y) * 0.5;

    float travel = distance(previousCenter, currentCenter);
    if (travel < 1.0) {
        return;
    }

    float progress = easeOutCubic(clamp(elapsed / DURATION, 0.0, 1.0));
    vec2 tail = mix(previousCenter, currentCenter, progress);
    vec2 halfSize = vec2(currentSize.x * 0.5, max(currentSize.y * 0.75, 2.0));
    float distanceToSmear = sdSweptBox(fragCoord, tail, currentCenter, halfSize);
    float core = 1.0 - smoothstep(-1.0, 1.0, distanceToSmear);
    float glowRadius = max(min(halfSize.x, halfSize.y), 1.0);
    float glow = exp(-max(distanceToSmear, 0.0) / (glowRadius * 0.75));

    vec2 axis = currentCenter - tail;
    float axisLengthSquared = max(dot(axis, axis), 0.0001);
    float along = clamp(dot(fragCoord - tail, axis) / axisLengthSquared, 0.0, 1.0);
    float life = 1.0 - smoothstep(0.55, 1.0, progress);
    vec3 smearColor = iCurrentCursorColor.rgb;
    float glowAlpha = glow * mix(0.01, 0.05, along) * life;
    float coreAlpha = core * mix(0.38, 0.92, along) * life * iCurrentCursorColor.a;

    fragColor.rgb += smearColor * glowAlpha * iCurrentCursorColor.a;
    fragColor = mix(fragColor, vec4(smearColor, 1.0), coreAlpha);
}
