%% CO2 and Carbon Intensity Indicator (CII) analysis
% Hybrid Offshore Vessel - Academic Team Project (2025)
% CII = total CO2 emissions / transport work

clear; clc; close all;

scenarios = ["good_weather", "medium_weather", "bad_weather"];
projectRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));

massDisplacement_t = 6100;
lightweight_t = 3050;              % assumption used in the project report
DWT_t = massDisplacement_t - lightweight_t;
distance_nm = 280.705;             % route distance used in the project analysis
transportWork_tnm = DWT_t * distance_nm;

fprintf('CO2 and CII summary\n');
fprintf('-----------------------------------------------\n');
fprintf('%-15s %12s %15s\n', 'Scenario', 'CO2 [t]', 'CII [g/t-nm]');

for i = 1:numel(scenarios)
    scenario = scenarios(i);
    filePath = fullfile(projectRoot, 'data', scenario, 'co2_emissions.csv');
    data = readtable(filePath);

    totalCO2_t = data.cumulative_co2_engine1_t + ...
                 data.cumulative_co2_engine2_t + ...
                 data.cumulative_co2_engine3_t;

    totalCO2_g = totalCO2_t(end) * 1e6;
    CII = totalCO2_g / transportWork_tnm;

    fprintf('%-15s %12.2f %15.2f\n', scenario, totalCO2_t(end), CII);
end
