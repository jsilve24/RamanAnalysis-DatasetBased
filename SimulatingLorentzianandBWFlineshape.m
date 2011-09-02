a1 = 1457;
w1 = 102;
xc1 = 1590;
y0 = 2;
I0 = 10;
xcBWF = 1445;
gamma = 112;
q = 123.5;


x = -100:3000;
y = y0+(2*a1/pi)*(w1./(4*(x-xc1).^2+w1^2))+...
    I0*(1+(x-xcBWF)./(q*gamma)).^2./(1+((x-xcBWF)/gamma).^2);
plot(x,y);
