function Score = spatial_var(RawImage)
% RawImage = double(imread(FluorImage));
ThresImage = RawImage-imopen(RawImage,strel('disk',50));
thImage = imclose(stdfilt(ThresImage),strel('disk',3));
thImage2 = imclose(thImage,strel('disk',3));
thImage2 = thImage2>10;
thImage2 = imclose(thImage2,strel('disk',5));
thImage2 = imfill(thImage2,'holes');
thImage2 = bwareaopen(thImage2,1000);
thImage2 = stdfilt(RawImage.*uint16(thImage2))./double(RawImage);
Score = sum(thImage2(:));
