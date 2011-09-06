% RAMANDATASETdriver

% clear classes;
load TestData.mat;
<<<<<<< HEAD
spec = ramandataset({sample_7_dried,'sample_7_dried'},...
    {sample_8_dried,'sample_8_dried'},{sample_9_dried,'sample_9_dried'});
=======
% sample_7_dried = sample_7_dried(1:end-10,:);
spec = ramandataset({sample_7_dried,'sample_7_dried'},...
    {sample_8_dried,'sample_8_dried'},{sample_9_dried,'sample_9_dried'});

% % Testing Overloaded Arithmetic Operators
% disp(spec(4,1));
% spec=spec./spec(:,1);
% disp(spec(4,1));
>>>>>>> 062a385... RAMANDATASET v0.1
