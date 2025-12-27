clc 
ms = 290;
mu = 59;
ks = 16000;
kt = 190000;
c  = 800;   % constant damping for now
data = readtable('road_profiles.csv');

t  = data.t;               % time vector
zr = data.profile_5;       % road profile 1
dt = t(2) - t(1);          % sampling time
zr_in = [t zr];   
%% 
clc
zs=out.zs_out;
jerk=out.jerk_out;

rms_zs = sqrt(mean(zs.^2));
max_zs = max(abs(zs));
rms_jerk = sqrt(mean(jerk.^2));
jerk_max = max(abs(jerk));
comfort_score = ...
    0.5 * rms_zs + ...
    max_zs + ...
    0.5 * rms_jerk + ...
    jerk_max;
fprintf('rms_zs      = %.6e\n', rms_zs);
fprintf('max_zs      = %.6e\n', max_zs);
fprintf('rms_jerk    = %.6e\n', rms_jerk);
fprintf('jerk_max    = %.6e\n', jerk_max);
fprintf('comfort     = %.6e\n', comfort_score);



