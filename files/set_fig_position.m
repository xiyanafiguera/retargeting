function fig = set_fig_position(fig,varargin)
%
% Set the position of a figure
%
persistent h

% Make enough handlers at the first
if isempty(h), for i = 1:10,h{i}.first_flag = true; end; end


% Parse options
p = inputParser;
addParameter(p,'position',[0.0,0.5,0.3,0.5]);
addParameter(p,'ADD_TOOLBAR',1);
addParameter(p,'DISABLE_TOOLBAR',1);
addParameter(p,'AXIS_EQUAL',1);
addParameter(p,'AXES_LABEL',1);
addParameter(p,'view_info','');
addParameter(p,'axis_info','');
addParameter(p,'SET_DRAGZOOM',1);
addParameter(p,'GRID_ON',1);
addParameter(p,'HOLD_ON',1);
addParameter(p,'SET_LIGHT',1);
addParameter(p,'MULTIPLE_MONITOR',0); % handling multiple-monitors
addParameter(p,'monitor_idx',1); % index of the monitor in multiple-monitors case
addParameter(p,'SET_BG_WHITE',1);
addParameter(p,'title_str','');
addParameter(p,'title_fs',20);

addParameter(p,'xm','');
addParameter(p,'ym','');

parse(p,varargin{:});
position = p.Results.position;
ADD_TOOLBAR = p.Results.ADD_TOOLBAR;
DISABLE_TOOLBAR = p.Results.DISABLE_TOOLBAR;
AXIS_EQUAL = p.Results.AXIS_EQUAL;
AXES_LABEL = p.Results.AXES_LABEL;
view_info = p.Results.view_info;
axis_info = p.Results.axis_info;
SET_DRAGZOOM = p.Results.SET_DRAGZOOM;
GRID_ON = p.Results.GRID_ON;
HOLD_ON = p.Results.HOLD_ON;
SET_LIGHT = p.Results.SET_LIGHT;
MULTIPLE_MONITOR = p.Results.MULTIPLE_MONITOR;
monitor_idx = p.Results.monitor_idx;
SET_BG_WHITE = p.Results.SET_BG_WHITE;
title_str = p.Results.title_str;
title_fs = p.Results.title_fs;

xm = p.Results.xm;
ym = p.Results.ym;


if h{fig.Number}.first_flag || ~ishandle(h{fig.Number}.fig)
    h{fig.Number}.first_flag = false;
    h{fig.Number}.fig = fig;
    
    if MULTIPLE_MONITOR
        MP = get(0, 'MonitorPositions');
        sz = MP(monitor_idx,3:4);
        fig_pos = [position(1)*sz(1),position(2)*sz(2),position(3)*sz(1),position(4)*sz(2)];
        fig_pos(1:2) = fig_pos(1:2) + MP(monitor_idx,1:2);
        set(fig,'Position',fig_pos);
    else
        % Single monitor case
        % Current size of the screen
        sz = get(0, 'ScreenSize');
        % Set the position of a figure relative to the screen size
        fig_pos = [position(1)*sz(3),position(2)*sz(4),position(3)*sz(3),position(4)*sz(4)];
        set(fig,'Position',fig_pos);
    end
    
    if ~isempty(xm) && ~isempty(ym)
        subaxes(fig,1,1,1,xm,ym);
    end
    
    
    % Add toolbar to a figure
    if ADD_TOOLBAR
        addToolbarExplorationButtons(gcf);
    end
    
    % Disable toolbar at the upper right of axes
    if DISABLE_TOOLBAR
        ax = gca;
        ax.Toolbar = [];
    end
    
    % Axis equal
    if AXIS_EQUAL
        axis equal;
    end
    
    % Set axes strings
    if AXES_LABEL
        xlabel('X','fontsize',20,'fontname','consolas');
        ylabel('Y','fontsize',20,'fontname','consolas');
        zlabel('Z','fontsize',20,'fontname','consolas');
    end
    
    % View info
    if ~isempty(view_info)
        view(view_info(1),view_info(2));
    end
    
    % Axis info
    if ~isempty(axis_info)
        axis(axis_info);
    end
    
    % Set dragzoom
    if SET_DRAGZOOM
        dragzoom;
    end
    
    % Grid on
    if GRID_ON
        grid_on('color','k','alpha',0.9);
    end
    
    % Hold on
    if HOLD_ON
        hold on;
    end
    
    % Cam light
    if SET_LIGHT
        camlight('infinite'); material('dull'); % cam light
    end
    
    % Make BG While
    if SET_BG_WHITE
        set(gcf,'Color','w');
    end
    
    % Title
    if ~isempty(title_str)
        h{fig.Number}.title = title(title_str,'fontname','consolas','fontsize',title_fs);
    end
else
    % Title
    if ~isempty(title_str)
        h{fig.Number}.title.String = title_str;
    end
end


