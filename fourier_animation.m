
% 方波 + 余弦波分解 动画（保存为 GIF）
clear; clc; close all;

% ===== 时间轴 =====
t = linspace(-0.5, 0.5, 2000);

% ===== 方波：周期=1，关于t=0偶对称，幅度 -0.5~+0.5 =====
y_sq = square(2*pi*1*t + pi/2);
y_sq = y_sq / 2;

% ===== 频率取值：正负对称 =====
N = 5;
n_vals = -N:N;
n_vals(n_vals == 1) = [];   % 频率=1 留给方波

% 按 |n| 从小到大排序，动画更自然
[~, idx] = sort(abs(n_vals));
n_vals = n_vals(idx);

% ===== 预计算所有振幅 =====
Cn_vals = zeros(size(n_vals));
for k = 1:length(n_vals)
    n = n_vals(k);
    Cn_vals(k) = 0.5 * sin(n*pi/2) / (n*pi/2);
end

% ===== 绘图初始化 =====
figure('Position', [100 100 1200 700], 'Color', 'w', ...
       'MenuBar', 'figure');
hold on; grid on; box on;

axis([-0.5 0.5 -5 5 -0.5 0.5]);
set(gca, 'YTick', -5:1:5);
set(gca, 'ZTick', [-0.5 -0.25 0 0.25 0.5]);
set(gca, 'XTick', [-0.5 -0.25 0 0.25 0.5]);

xlabel('时间 t');
ylabel('频率 n');
zlabel('幅度');

view(45, 25);

% ===== GIF 保存初始化 =====
gif_filename = 'fourier_animation.gif';
gif_delay = 0.5;
frame_count = 0;

% ===== 标题 =====
main_title = '周期函数 = 其频率整数倍谐波之和';

% =========================================================
% 第一帧：只画方波（频率=1 平面）
% =========================================================
plot3(t, ones(size(t)), y_sq, 'b', 'LineWidth', 2.5);
title(main_title);
drawnow;

% 保存第一帧
frame_count = frame_count + 1;
frame = getframe(gcf);
im = frame2im(frame);
[A, map] = rgb2ind(im, 256);
imwrite(A, map, gif_filename, 'gif', ...
        'LoopCount', Inf, 'DelayTime', gif_delay);

pause(1);

% =========================================================
% 逐帧：依次画各频率的余弦波
% =========================================================
for k = 1:length(n_vals)
    n = n_vals(k);
    Cn = Cn_vals(k);
    
    % 频率为 n 的余弦波
    y_n = Cn * cos(2*pi*n*t);
    
    % 画余弦波
    plot3(t, n*ones(size(t)), y_n, 'Color', [0.85 0.33 0.10], ...
          'LineWidth', 1.5);
    
    % t=0 处红色振幅点
    plot3(0, n, Cn, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    
    % 红色竖线：从 z=0 连到红点
    plot3([0 0], [n n], [0 Cn], 'r-', 'LineWidth', 1);
    
    % 底面紫色投影点：z=0
    plot3(0, n, 0, 'mo', 'MarkerSize', 8, 'MarkerFaceColor', [0.8 0.2 0.8]);
    
    title(main_title);
    drawnow;
    
    % 保存当前帧
    frame_count = frame_count + 1;
    frame = getframe(gcf);
    im = frame2im(frame);
    [A, map] = rgb2ind(im, 256);
    imwrite(A, map, gif_filename, 'gif', ...
            'WriteMode', 'append', 'DelayTime', gif_delay);
    
    pause(0.6);
end

% =========================================================
% 最后一帧：红点连成 sinc 包络线
% =========================================================
[sorted_n, idx2] = sort(n_vals);
plot3(zeros(size(sorted_n)), sorted_n, Cn_vals(idx2), ...
      'r-', 'LineWidth', 2);

title(main_title);
drawnow;

% 保存最后一帧
frame_count = frame_count + 1;
frame = getframe(gcf);
im = frame2im(frame);
[A, map] = rgb2ind(im, 256);
imwrite(A, map, gif_filename, 'gif', ...
        'WriteMode', 'append', 'DelayTime', gif_delay);

hold off;

