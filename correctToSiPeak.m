function [fixedx, y] = correctToSiPeak(x,y)
% CORRECTTOSIPEAK: takes ramanspectrum from sample on Si and adjusts
% wavenumbers artifact of detector by fitting to Si peak. 

    SIPEAK_CENTER = 518; %cm^-1
    SiPeak = fitSiPeak(x,y);
    shift = SIPEAK_CENTER - SiPeak.xc;
    fixedx = x(:) - shift;
%     fixedy = y; 

end %END CORRECTTOSIPEAK