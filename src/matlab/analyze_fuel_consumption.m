%% Fuel consumption analysis across weather scenarios
% Hybrid Offshore Vessel - Academic Team Project (2025)
% Post-processing of Simcenter Amesim exported data.

clear; clc; close all;

scenarios = ["good_weather", "medium_weather", "bad_weather"];
projectRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));

fprintf('Fuel consumption summary\n');
fprintf('------------------------\n');

for i = 1:numel(scenarios)
    scenario = scenarios(i);
    filePath = fullfile(projectRoot, 'data', scenario, 'fuel_consumption.csv');
    data = readtable(filePath);

    time = data.time_s;
    fuel1 = data.cumulative_fuel_engine1_t;
    fuel2 = data.cumulative_fuel_engine2_t;
    fuel3 = data.cumulative_fuel_engine3_t;
    totalFuel = fuel1 + fuel2 + fuel3;

    fprintf('%-15s: %.2f t\n', scenario, totalFuel(end));

    figure('Name', scenario + " - Fuel Consumption");
    plot(time, totalFuel, 'LineWidth', 1.5); hold on;
    plot(time, fuel1, 'LineWidth', 1.0);
    plot(time, fuel2, 'LineWidth', 1.0);
    plot(time, fuel3, 'LineWidth', 1.0);
    xlabel('Time [s]');
    ylabel('Cumulative fuel consumption [t]');
    title(strrep(scenario, '_', ' ') + " - Fuel Consumption");
    legend('Total', 'Engine 1', 'Engine 2', 'Engine 3', 'Location', 'best');
    grid on;
end
