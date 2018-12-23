%Copyright (C) 2005  Barre-Piquot

%This program is free software; you can redistribute it and/or
%modify it under the terms of the GNU General Public License
%as published by the Free Software Foundation; either version 2
%of the License, or (at your option) any later version.

%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.

function [D,L]=bwdist2(img,methode)
%Distance transform
%
%D = bwdist (BW)
%[D,L] = bwdist (BW)
%[D,L] = bwdist (BW,METHOD)
%
%D = bwdist(BW) computes the Borgefors distance transform, which approaches the Euclidean distance of the binary image BW.
%For each pixel in BW, the distance transform assigns a number that is the distance between that pixel and the nearest nonzero pixel of BW. bwdist uses %the Borgefors distance metric by default. BW can have any dimension. D is the same size as BW. [D,L] = bwdist(BW) also computes the nearest-neighbor %transform and returns it as label matrix L, which has the same size as BW and D. Each element of L contains the linear index of the nearest nonzero %pixel of BW. [D,L] = bwdist(BW,METHOD) computes the distance transform, where METHOD specifies an alternate distance metric. METHOD can also be :
%
%the chessboard distance
%the cityblock distance
%
%
%bw = zeros(5,5); bw(2,2) = 1; bw(4,4) = 1
%[D,L] = bwdist(bw)
%
%
%bw = zeros(200,200); bw(50,50) = 1; bw(50,150) = 1;
%bw(150,100) = 1;
%D1 = bwdist(bw,'Borgefors');
%D2 = bwdist(bw,'Cityblock');
%D3 = bwdist(bw,'Chessboard');
%
%The label matrix L is not implemented and returns the binary matrix. 



	%definition of the infinite value
	infini=sum(size(img));

	%initialisation
	masq=(img~=1)*infini;
	D=zeros(size(img));
			
	s=size(masq);
	masq2=ones(s(1)+2,s(2)+2)*infini;		
	masq2(2:1+s(1),2:1+s(2))=masq;
	filterDesc=ones(3,3)*infini;
	filterAsc=ones(3,3)*infini;
	
	if (nargin==1)
		methode='Borgefors';
	end
	
	if(strcmp(methode,'Borgefors'))
	% definition of the Borgefors transform filters
   		filterDesc(1,1)=4;
		filterDesc(1,2)=3;
		filterDesc(1,3)=4;
		filterDesc(2,1)=3;
		filterDesc(2,2)=0;
		
		filterAsc(3,3)=4;
		filterAsc(3,2)=3;
		filterAsc(3,1)=4;
		filterAsc(2,3)=3;
		filterAsc(2,2)=0;
		
	else 		
		if(strcmp(methode,'Chessboard'))
   		% definition of the Chessboard transform filters
    			filterDesc(1,1)=1;
			filterDesc(1,2)=1;
			filterDesc(1,3)=1;
			filterDesc(2,1)=1;
    			filterDesc(2,2)=0;
										
    			filterAsc(2,2)=0;
			filterAsc(2,3)=1;
			filterAsc(3,1)=1;
			filterAsc(3,2)=1;
			filterAsc(3,3)=1;
		else 		
			if(strcmp(methode,'Cityblock'))
   			% definition of the Cityblock transform filters
    				filterDesc(1,1)=2;
				filterDesc(1,2)=1;
				filterDesc(1,3)=2;
				filterDesc(2,1)=1;
    				filterDesc(2,2)=0;
										
	    			filterAsc(2,2)=0;
				filterAsc(2,3)=1;
				filterAsc(3,1)=2;
				filterAsc(3,2)=1;
				filterAsc(3,3)=2;			
			end
		end
	end
	
	%first filtering	
	masq2=applyToward(masq2,filterDesc);
	%last filtering
	masq2=applyBackward(masq2,filterAsc);
	
	D=masq2(2:1+s(1),2:1+s(2));
	
	if(strcmp(methode,'Borgefors'))
		D=D/3;
	end
	L=img;
	
	
	
end

%Apply a filter to a matrix toward
function M = applyToward(img, filter)

	s = size(img);
	p = zeros(9,1);
	M=img;
	for i=2:s(1)-1
		for j=2:s(2)-1
			p(1) = filter(1,1) + M(i-1, j-1);
			p(2) = filter(1,2) + M(i-1, j);
			p(3) = filter(1,3) + M(i-1, j+1);
			p(4) = filter(2,1) + M(i, j-1);
			p(5) = filter(2,2) + M(i, j);
			p(6) = filter(2,3) + M(i, j+1);
			p(7) = filter(3,1) + M(i+1, j-1);
			p(8) = filter(3,2) + M(i+1, j);
			p(9) = filter(3,3) + M(i+1, j+1);
			
			M(i,j) = min(p);
		end
	end
	
end

%Apply a filter to a matrix backward
function M = applyBackward(img, filter)

	s = size(img);
	p = zeros(9,1);
	M=img;
	for i=s(1)-1:-1:2
		for j=s(2)-1:-1:2
			p(1) = filter(1,1) + M(i-1, j-1);
			p(2) = filter(1,2) + M(i-1, j);
			p(3) = filter(1,3) + M(i-1, j+1);
			p(4) = filter(2,1) + M(i, j-1);
			p(5) = filter(2,2) + M(i, j);
			p(6) = filter(2,3) + M(i, j+1);
			p(7) = filter(3,1) + M(i+1, j-1);
			p(8) = filter(3,2) + M(i+1, j);
			p(9) = filter(3,3) + M(i+1, j+1);
			
			M(i,j) = min(p);
		end
	end

end
