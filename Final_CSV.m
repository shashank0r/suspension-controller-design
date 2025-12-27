clc; clear;

% =============================
% FIXED MODEL PARAMETERS
% =============================
ms = 290;
mu = 59;
ks = 16000;
kt = 190000;

dt = 0.005;     % FIXED by problem statement

% =============================
% LOAD ROAD PROFILES
% =============================
data = readtable('road_profiles.csv');
t = data.t;

profile_names = ...
    {'profile_1','profile_2','profile_3','profile_4','profile_5'};

% =============================
% RESULT STORAGE
% =============================
results = cell(5,5);  % profile, rms_zs, max_zs, rms_jerk, comfort

% =============================
% LOOP OVER PROFILES
% =============================
for i = 1:5
    fprintf('\n============================\n');
    fprintf('Running %s\n', profile_names{i});
    fprintf('============================\n');

    % --- road input ---
    zr = data.(profile_names{i});
    zr_in = [t zr];

    % --- run simulation ---
    out = sim('quarter_car', ...
              'SrcWorkspace','base', ...
              'FastRestart','off');

    % --- extract signals ---
    zs   = out.zs_out(:);
    jerk = out.jerk_out(:);

    % =============================
    % METRIC COMPUTATION
    % =============================
    zs_rel = zs - zs(1);

    rms_zs   = sqrt(mean(zs_rel.^2));
    max_zs   = max(abs(zs_rel));
    rms_jerk = sqrt(mean(jerk.^2));
    jerk_max = max(abs(jerk));

    comfort = 0.5*rms_zs + max_zs + 0.5*rms_jerk + jerk_max;

    % --- store ---
    results{i,1} = profile_names{i};
    results{i,2} = rms_zs;
    results{i,3} = max_zs;
    results{i,4} = rms_jerk;
    results{i,5} = comfort;

    % --- display ---
    fprintf('rms_zs    = %.6e\n', rms_zs);
    fprintf('max_zs    = %.6e\n', max_zs);
    fprintf('rms_jerk  = %.6e\n', rms_jerk);
    fprintf('comfort   = %.6e\n', comfort);
end

% =============================
% CREATE SUBMISSION CSV
% =============================
submission = cell2table(results, ...
    'VariableNames', ...
    {'profile','rms_zs','max_zs','rms_jerk','comfort_score'});

writetable(submission,'submission.csv');

fprintf('\nsubmission.csv created successfully\n');
