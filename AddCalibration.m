function cal=AddCalibration;

pixs=1:1600;%valid for files with Andor camera, mid-2009 onward
cal=2.625e-13+2.63255*pixs'-3.42113e-4*pixs'.*pixs';%valid for files 11Nov2009 onward
%cal=-1.575e-12+2.498*pixs'-2.758e-4*pixs'.*pixs';%valid for files 5Nov2009 onward
%pixs=1:1339;
%cal=3575.09-2.01018*pixs'-4.927e-4*pixs'.*pixs';%valid for files 9April2009 onward
%cal=3611.15821-1.94397*pixs'-5.62315e-4*pixs'.*pixs';%valid for files 4February2008 onward
%cal=3543.99-1.91545*pixs'-5.55635e-4*pixs'.*pixs';%valid for files 6/28/07 onward
%cal=3556.75-2.2793*pixs'-1.937e-5*pixs'.*pixs'-1.9299e-7*pixs'.*pixs'.*pixs';%valid for files 05/04/05 
