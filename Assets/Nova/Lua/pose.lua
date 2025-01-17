local poses = {
    ['王二宫'] = {
        ['normal'] = 'body+mouth_smile+eye_normal+eyebrow_normal+hair',
    },
    ['陈高天'] = {
        ['normal'] = 'body+mouth_smile+eye_normal+eyebrow_normal+hair',
        ['cry'] = 'body+mouth_smile+eye_cry+eyebrow_normal+hair',
    },
    ['张浅野'] = {
        ['normal'] = 'body+mouth_close+eye_normal+eyebrow_normal+hair',
    },
    ['孙西本'] = {
        ['normal'] = 'body+mouth_close+eye_normal+eyebrow_normal+hair',
    },

    ['cg'] = {
        ['rain'] = 'rain_back',
        ['rain_final'] = 'rain_back+rain_text',
    },
}

function get_pose(obj, pose_name)
    if string.find(pose_name, '+') then
        return pose_name
    end

    local pose = poses[obj.luaGlobalName] and poses[obj.luaGlobalName][pose_name]
    if pose then
        return pose
    end

    warn('Unknown pose ' .. dump(pose_name) .. ' for composite sprite ' .. dump(obj))
    return pose_name
end
