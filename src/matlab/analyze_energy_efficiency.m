%% Vessel and propulsion energy-efficiency analysis
% Hybrid Offshore Vessel - Academic Team Project (2025)
% Methodology follows the original project: engine fuel power and battery
% contribution are treated as inputs; electric load and propeller power are outputs.

clear; clc; close all;

scenarios = ["good_weather", "medium_weather", "bad_weather"];
projectRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));

fprintf('Energy-efficiency summary\n');
fprintf('-------------------------------------------------------------\n');
fprintf('%-15s %12s %12s %12s\n', 'Scenario', 'Input [GJ]', 'Vessel eff.', 'Prop. eff.');

for i = 1:numel(scenarios)
    scenario = scenarios(i);
    filePath = fullfile(projectRoot, 'data', scenario, 'power_flow.csv');
    data = readtable(filePath);

    time = data.time_s;
    fuelPower = data.fuel_power_engine1_kw + data.fuel_power_engine2_kw + data.fuel_power_engine3_kw;

    % Amesim export sign convention used in the original project:
    % negative battery power means the battery contributes power to the system.
    batteryContribution = -data.battery_power_kw;
    inputPower = fuelPower + batteryContribution;

    electricLoadPower = data.electric_load_kw;
    propellerPower = data.propeller_power_kw;
    outputPower = electricLoadPower + propellerPower;

    % kW*s = kJ. Divide by 1e6 to report GJ.
    inputEnergy_kJ = trapz(time, inputPower);
    outputEnergy_kJ = trapz(time, outputPower);
    propellerEnergy_kJ = trapz(time, propellerPower);

    inputEnergy_GJ = inputEnergy_kJ / 1e6;
    vesselEfficiency = 100 * outputEnergy_kJ / inputEnergy_kJ;
    propulsionEfficiency = 100 * propellerEnergy_kJ / inputEnergy_kJ;

    fprintf('%-15s %12.2f %11.2f%% %11.2f%%\n', scenario, inputEnergy_GJ, vesselEfficiency, propulsionEfficiency);

    figure('Name', scenario + " - Power Flow");
    plot(time, inputPower, 'LineWidth', 1.3); hold on;
    plot(time, outputPower, 'LineWidth', 1.3);
    xlabel('Time [s]');
    ylabel('Power [kW]');
    title(strrep(scenario, '_', ' ') + " - Power Flow");
    legend('Input power', 'Output power', 'Location', 'best');
    grid on;
end
