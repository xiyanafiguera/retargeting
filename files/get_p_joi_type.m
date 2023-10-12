function p = get_p_joi_type(chain,joi_chain,joi_type)
%
% Get the position of the chain from JOI type
%
disp("get p joi type");
disp(get_joint_idx_from_joi_type(joi_chain,joi_type));
p = chain.joint(get_joint_idx_from_joi_type(joi_chain,joi_type)).p;
disp(p)