function [z, out1] = ClusteringCost(m, X)




    data=X;
    center=m;
    out = zeros(size(center, 1), size(data, 1));

    if size(center, 2) > 1
    for k = 1:size(center, 1)
	out(k, :) = sqrt(sum(((data-ones(size(data, 1), 1)*center(k, :)).^2)'));
    end
    else	% 1-D data
    for k = 1:size(center, 1)
	out(k, :) = abs(center(k)-data)';
    end
    end
    
    
    
    
    out1.d=out;
    [dmin, ind] = min(out, [], 2);
    ind;
    out1.ind=ind;
    
    z=mean(mean(out));
    out1.WCD=z;
    out1.ind=ind;
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
end