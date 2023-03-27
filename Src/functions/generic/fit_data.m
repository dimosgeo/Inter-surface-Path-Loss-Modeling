function fit_data(distance_array,pathloss_array,l,rmse_x,plfit_x)

    x=distance_array;
    y=pathloss_array;
    y2=10.^(y/10);
    y2=(1./y2).*(x.^2);
    temp_p = find(ischange(y2, 'linear', 'SamplePoints', x,'MaxNumChanges',1),1);
    K=20*log10(4*pi/l);
    fitfun = fittype( @(n,c,x) 10*n*log10(x)+K+c);
    if(isempty(temp_p))
        [fitted_curve1,gof1] = fit(distance_array',pathloss_array',fitfun,'StartPoint',[1,1]);
        error_array=(ones(1,length(x))*gof1.rmse);
        n_array=(ones(1,length(x))*fitted_curve1.n);

        xlabel(rmse_x,'Mirror Distance (m)');
        ylabel(rmse_x,'RMSE (dB)');    
        plot(rmse_x,x,error_array);
        xlim(rmse_x,[min(x),max(x)]);
    
        xlabel(plfit_x,'Mirror Distance (m)');
        ylabel(plfit_x,'PathLoss (dB)');
        plot(plfit_x,x,y,'DisplayName',['n=',num2str(n_array(1))],'Color','r');  
        legend(plfit_x,'show','Location','southeast','AutoUpdate','off');   
    else
        [fitted_curve1,gof1] = fit(distance_array(1:temp_p)',pathloss_array(1:temp_p)',fitfun,'StartPoint',[1,1]);
        [fitted_curve2,gof2] = fit(distance_array(temp_p:end)',pathloss_array(temp_p:end)',fitfun,'StartPoint',[1,1]);
        error_array=[ones(1,temp_p)*gof1.rmse,ones(1,length(pathloss_array)-temp_p)*gof2.rmse];
        n_array=[ones(1,temp_p)*fitted_curve1.n,ones(1,length(pathloss_array)-temp_p)*fitted_curve2.n];

        xlabel(rmse_x,'Mirror Distance (m)');
        ylabel(rmse_x,'RMSE (dB)');    
        plot(rmse_x,x,error_array);
        xline(rmse_x,x(temp_p));
        xlim(rmse_x,[min(x),max(x)]);
        set(rmse_x,'XTick',unique([x(1),x(temp_p),get(rmse_x,'XTick'),x(end)]))
    
        xlabel(plfit_x,'Mirror Distance (m)');
        ylabel(plfit_x,'PathLoss (dB)');
        plot(plfit_x,x(1:temp_p),y(1:temp_p),'DisplayName',['n=',num2str(n_array(1))],'Color','r');  
        plot(plfit_x,x(temp_p:end),y(temp_p:end),'DisplayName',['n=',num2str(n_array(end))],'Color','g');
        legend(plfit_x,'show','Location','southeast','AutoUpdate','off');
        xline(plfit_x,x(temp_p),'k');
        xlim(plfit_x,[min(x),max(x)]);
        set(plfit_x,'XTick',unique([x(1),x(temp_p),get(plfit_x,'XTick'),x(end)]))
    end
end