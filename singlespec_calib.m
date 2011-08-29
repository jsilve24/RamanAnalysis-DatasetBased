function outspec = singlespec_calib(filename)

% JWG 5/17/2010
% Loads a *.asc single spectrum data taken with Joan's LabView program.
% First row is originally 0:1599 rather than 1:1600

spec = load(filename);
cal = AddCalibration;

outspec = spec';
outspec(:,1) = cal(spec(1,:)+1);