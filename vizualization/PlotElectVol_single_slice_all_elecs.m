function PlotElectVol_individual_slices(elecMatrix, elecRgb, V,elecId, slice2d_axes, all_labels, slice)



if isempty(elecMatrix) || isempty(V)
    return;
end

mri.vol = V;
mx=max(max(max(mri.vol)))*.7;
mn=min(min(min(mri.vol)));
sVol=size(mri.vol);

xyz(:,1)=elecMatrix(:,2);
xyz(:,2)=elecMatrix(:,1);
xyz(:,3)=sVol(3)-elecMatrix(:,3);



xyz_no_elecId = xyz;
xyz_no_elecId(elecId,:) = [];



elec_label = all_labels{elecId};
font_size_label = 8;


imshow(squeeze(mri.vol(:,xyz(elecId,1),:)),[mn mx],'parent',slice2d_axes(1));
title(elec_label, 'Fontsize', 40)

% imshow(rot90(rot90(squeeze(mri.vol(:,xyz(elecId,1),:)))),[mn mx],'parent',slice2d_axes(1));
set(slice2d_axes(1),'nextplot','add');

%electrodes with same coordinate

plot(xyz(elecId,3),xyz(elecId,2),'.','color',elecRgb(elecId,:),'markersize',30,'parent',slice2d_axes(1));
hold on
text(xyz(elecId,3),xyz(elecId,2), elec_label, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top', 'FontSize', font_size_label, 'Color', 'w', 'parent',slice2d_axes(1))

other_elecs = find(xyz(:,1) == xyz(elecId,1));
if ~isempty(other_elecs)
    other_elecs(other_elecs == elecId) = [];
    hold on
    for io = 1:length(other_elecs)
        ioo = other_elecs(io);
        plot(xyz(ioo,3),xyz(ioo,2),'.','color','g','markersize',30,'parent',slice2d_axes(1));
        text(xyz(ioo,3),xyz(ioo,2), all_labels{ioo}, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top', 'FontSize', font_size_label, 'Color', 'w', 'parent',slice2d_axes(1))
    end
else
end

axis(slice2d_axes(1),'square');
set(slice2d_axes(1),'xdir','reverse');
mxX=max(squeeze(mri.vol(:,xyz(elecId,1),:)),[],2);
mxY=max(squeeze(mri.vol(:,xyz(elecId,1),:)),[],1);
limXa=max(intersect(1:(sVol(3)/2),find(mxX==0)));
limXb=min(intersect((sVol(3)/2:sVol(3)),find(mxX==0)));
limYa=max(intersect(1:(sVol(2)/2),find(mxY==0)));
limYb=min(intersect((sVol(2)/2:sVol(2)),find(mxY==0)));
%keep image square
tempMin=min([limXa limYa]);
tempMax=max([limXb limYb]);
if tempMin<tempMax
    axis(slice2d_axes(1),[tempMin tempMax tempMin tempMax]);
end
set(slice2d_axes(1),'xtick',[],'ytick',[],'xdir','reverse');

%axes(slice2d_axes(2))
imshow(squeeze(mri.vol(xyz(elecId,2),:,:)),[mn mx],'parent',slice2d_axes(2));
title(elec_label, 'Fontsize', 40)

set(slice2d_axes(2),'nextplot','add');
plot(slice2d_axes(2),xyz(elecId,3),xyz(elecId,1),'.','color',elecRgb(elecId,:),'markersize',30);
hold on
text(slice2d_axes(2),xyz(elecId,3),xyz(elecId,1), elec_label, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top', 'FontSize', font_size_label, 'Color', 'w', 'parent',slice2d_axes(2))

other_elecs = find(xyz(:,2) == xyz(elecId,2));
if ~isempty(other_elecs)
    other_elecs(other_elecs == elecId) = [];
    hold on
    for io = 1:length(other_elecs)
        ioo = other_elecs(io);
        plot(slice2d_axes(2),xyz(ioo,3),xyz(ioo,1),'.','color','g','markersize',30,'parent',slice2d_axes(2));
        text(slice2d_axes(2),xyz(ioo,3),xyz(ioo,1), all_labels{ioo}, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top', 'FontSize', font_size_label, 'Color', 'w', 'parent',slice2d_axes(2))
    end
else
end


axis(slice2d_axes(2),'square');
mxX=max(squeeze(mri.vol(xyz(elecId,2),:,:)),[],2);
mxY=max(squeeze(mri.vol(xyz(elecId,2),:,:)),[],1);
limXa=max(intersect(1:(sVol(3)/2),find(mxX==0)));
limXb=min(intersect((sVol(3)/2:sVol(3)),find(mxX==0)));
limYa=max(intersect(1:(sVol(1)/2),find(mxY==0)));
limYb=min(intersect((sVol(1)/2:sVol(1)),find(mxY==0)));
%keep image square
centershift = sVol(3)/2-((limXb-limXa)/2+limXa);
if limYa-(limYb-limYa) < limYb+(limYb-limYa)
    axis(slice2d_axes(2),[limYa-(limYb-limYa)*0.05 limYb+(limYb-limYa)*0.05...
        limYa-(limYb-limYa)*0.05-centershift limYb+(limYb-limYa)*0.05-centershift ])
end
% tempMin=min([limXa limYa]);
% tempMax=max([limXb limYb]);
% if tempMin<tempMax
%     axis([tempMin tempMax tempMin tempMax]);
% end
set(slice2d_axes(2),'xtick',[],'ytick',[]);


%axes(slice2d_axes(3))
imshow(squeeze(mri.vol(:,:,xyz(elecId,3)))',[mn mx],'parent',slice2d_axes(3));
title(elec_label, 'Fontsize', 40)
set(slice2d_axes(3),'nextplot','add');
plot(slice2d_axes(3),xyz(elecId,2),xyz(elecId,1),'.','color',elecRgb(elecId,:),'markersize',30);
hold on
text(slice2d_axes(3),xyz(elecId,2),xyz(elecId,1), elec_label, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top', 'FontSize', font_size_label, 'Color', 'w', 'parent',slice2d_axes(3))

other_elecs = find(xyz(:,3) == xyz(elecId,3));
if ~isempty(other_elecs)
    other_elecs(other_elecs == elecId) = [];
    hold on
    for io = 1:length(other_elecs)
        ioo = other_elecs(io);
        plot(slice2d_axes(3),xyz(ioo,2),xyz(ioo,1),'.','color','g','markersize',30,'parent',slice2d_axes(3));
        text(slice2d_axes(3),xyz(ioo,2),xyz(ioo,1), all_labels{ioo}, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top', 'FontSize', font_size_label, 'Color', 'w', 'parent',slice2d_axes(3))
    end
else
end


axis(slice2d_axes(3),'square');
mxX=max(squeeze(mri.vol(:,:,xyz(elecId,3))),[],2);
mxY=max(squeeze(mri.vol(:,:,xyz(elecId,3))),[],1);
limXa=max(intersect(1:(sVol(3)/2),find(mxX==0)));
limXb=min(intersect((sVol(3)/2:sVol(3)),find(mxX==0)));
limYa=max(intersect(1:(sVol(2)/2),find(mxY==0)));
limYb=min(intersect((sVol(2)/2:sVol(2)),find(mxY==0)));
%keep image square
centershift = sVol(3)/2-((limYb-limYa)/2+limYa);
if limXa-(limXb-limXa) < limXb+(limXb-limXa)
    axis(slice2d_axes(3),[limXa-(limXb-limXa)*0.07 limXb+(limXb-limXa)*0.07...
        limXa-(limXb-limXa)*0.07-centershift limXb+(limXb-limXa)*0.07-centershift ])
end



% tempMin=min([limXa limYa]);
% tempMax=max([limXb limYb]);
% if tempMin<tempMax
%     axis([tempMin tempMax tempMin tempMax]);
% end

set(slice2d_axes(3),'nextplot','replace','xtick',[],'ytick',[]);
%set(slice2d_axes(3))%,'backgroundcolor',[0.98 0.98 0.98]);