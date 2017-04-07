function cax = azelaxes(figure, position)

dtr = pi/180

% Create axes object
cax = axes(figure, 'units', 'normalized', 'position', position, 'xtick', [], 'ytick', []);

% Code below was written by Dr. Siebold and slightly modified by Jason Koch

% get x-axis text color so grid is in same color
% tc = get(cax,'xcolor');
tc = [1 1 1];
ls = get(cax,'gridlinestyle');

% make a radial grid
    hold on;
    maxEl = 90;
    hhh=plot([-maxEl -maxEl maxEl maxEl],[-maxEl maxEl maxEl -maxEl]);
    set(gca,'dataaspectratio',[1 1 1],'plotboxaspectratiomode','auto')
    delete(hhh);


% define a circle
    th = 0:pi/50:2*pi;
    rmin = 0;
    rmax = 90;
    xunit = cos(th);
    yunit = sin(th);
% now really force points on x/y axes to lie on them exactly
    inds = 1:(length(th)-1)/4:length(th);
    xunit(inds(2:2:4)) = zeros(2,1);
    yunit(inds(1:2:5)) = zeros(3,1);
% plot background if necessary
    if ~isstr(get(cax,'color'))
       patch('xdata',xunit*rmax,'ydata',yunit*rmax, ...
             'edgecolor',tc,'facecolor',[0 0 0],...
             'handlevisibility','off');
    end

% draw radial circles


    for i=15:15:75
        hhh = plot(xunit*(90 - i),yunit*(90 - i),ls,'color',tc,'linewidth',1,...
                   'handlevisibility','off');
        text(0,(90 - i), ...
            [num2str(i)],'verticalalignment','bottom',...
            'horizontalalignment','center',...
            'handlevisibility','off','color',tc)
    end

% plot spokes
    for i = 15:15:345
        cs = cos(i*dtr); 
        sn = sin(i*dtr);
        plot([0 rmax*sn],[0 rmax*cs],ls,'color',tc,'linewidth',1,...
             'handlevisibility','off')
    end
% annotate spokes in degrees
    rt = 1.1*rmax;
    for i = 0:15:345
        text(rt*sin(i*dtr),rt*cos(i*dtr),int2str(i),...
             'horizontalalignment','center',...
             'handlevisibility','off','color','black');
    end
north = text(0,rt*1.15,'North','FontAngle','italic',...
             'FontSize',14,'FontWeight','bold',...
             'Color',[1 0 0],...
             'horizontalalignment','center',...
             'handlevisibility','on');
        text(rt*1.15,0,'East','FontAngle','italic',...
             'FontSize',14,'FontWeight','bold',...
             'Color',[1 0 0],...
             'horizontalalignment','left',...
             'handlevisibility','off');
        text(0,-rt*1.15,'South','FontAngle','italic',...
             'FontSize',14,'FontWeight','bold',...
             'Color',[1 0 0],...
             'horizontalalignment','center',...
             'handlevisibility','off');
         text(-rt*1.15,0,'West','FontAngle','italic',...
             'FontSize',14,'FontWeight','bold',...
             'Color',[1 0 0],...
             'horizontalalignment','right',...
             'handlevisibility','off');
        
         
         
% set view to 2-D
    view(2);
% set axis limits
    axis(rmax*[-1 1 -1.15 1.15]);

end