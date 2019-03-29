function I = expint3_n(omega,type,g,f)


switch type
    case 1 % Computes integral(exp(i*omega*(y-1/2)^2)/(1+y) dy, y=0..1)
        if omega == 10
            I = 0.355244291494720670892001033863 + 0.373087689606831412616598624402*1i;
        elseif omega == 20
            I = 0.112868004081694700749190714221 + 0.172757648002321650325153458559*1i;
        elseif omega == 40
            I = 0.112223452755344057324942606251 + 0.164841747098066719706153280134*1i;
        elseif omega == 80
            I = 0.110103152886593209770219865582 + 0.0857169740083850353882300299008*1i;
        elseif omega == 160
            I = 0.0730043779096728848597002654503 + 0.0723314949869741779972183720332*1i;
        else
            I = integral(@(x) f(x).*exp(1i*omega*g(x)),0,1);
        end
    case 2 % Computes integral(exp(i*omega*(x^2+x+1)^(1/3))/(1+y) dy, y=0..1)
        if omega == 10
            I = 0.151993647063347080948290906134 - 0.209711419876815991433633565605*1i;
        elseif omega == 20
            I = -0.130784273734174816176168664430 + 0.127232800319480083864333242749*1i;
        elseif omega == 40
            I = -0.0366694987795661439420641881911 - 0.0507174565952282338141027115670*1i;
        elseif omega == 80
            I = 0.0462317960527517084179580349442 + 0.00124657567822277175975453255464*1i;
        elseif omega == 160
            I = -0.0113024794864673814548567765064 - 0.0170341227889868641139357553734*1i;
        elseif omega == 320
            I = 0.00514610028565990310471495567264 + 0.0114816725968448307177199048975*1i;
        elseif omega == 640
            I = 0.00275442725183638856449619699618 + 0.00157815524558741881922883677358*1i;
        else
            I = integral(@(x) f(x).*exp(1i*omega*g(x)),0,1);
        end
end