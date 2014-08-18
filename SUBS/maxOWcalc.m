%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created: 16-Jul-2014 13:52:44
% Computer:GLNX86
% Matlab:7.9
% Author:NK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function maxOWcalc;dF
    load DD
    DD=main(DD,DD.MD,DD.f,DD.raw); %#ok<NASGU,NODEF>
    save DD
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DD=main(DD,MD,f,raw);dF
    T=disp_progress('init','building okubo weiss netcdfs')  ;
    my=OWinit(MD.sMean.Fout,raw,f);
    toAdd={'OkuboWeiss','log10NegOW'};
    for tt = MD.timesteps;
        T=disp_progress('show',T,numel(MD.timesteps),numel(MD.timesteps));
        if ~exist(MD.OWFout{tt},'file')
            tmpFile=[MD.OWFout{tt} 'tmp'];
            loop(f,my,toAdd,MD.Fout{tt},tmpFile);
            system(['mv ' tmpFile ' ' MD.OWFout{tt}])
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loop(f,my,tA,currFile,OWFile);dF
    OW=extrOW(my,f,currFile);
    initOWNcFile(OWFile,tA,size(OW));
    f.ncVP(OWFile,OW,tA{1});
    OW(isinf(OW) | OW>=0 | isnan(OW) )=nan;
    f.ncVP(OWFile,log10(-OW),tA{2});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  my=OWinit(MeanFile,raw,f);dF
    dF
    disp('init okubo weiss calcs...')
    try
        load my
        spmd
            my=MY{labindex}; %#ok<NODEF>
        end
    catch
        spmd
            my.RhoMean=single(f.ncvOne(f.ncv(MeanFile,'RhoMean')));
            my.Z=size(my.RhoMean,1);
            my.dx=single(raw.dx);
            my.dy=single(raw.dy);
            my.GOverF=single(raw.corio.GOverF);
            my.depth=single(f.ncvOne(raw.depth));
        end
        [MY]={(my{:})}; %#ok<NASGU>
        save('my.mat','MY');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function OW=extrOW(my,f,cF);dF
    spmd
        my.rhoHighPass=f.getHP(cF,f) - my.RhoMean;
        my.UV=getVels(my,f.repinZ);
        labBarrier
    end
    
    spmd
        uvg=UVgrads(my.UV,my.dx,my.dy,f.repinZ);
        ow = f.vc2mstr(okuweiss(getDefo(uvg)),1);
        labBarrier
    end
    OW=f.slMstrPrt(ow);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ow = okuweiss(d);dF
    ow = (-(d.vorticity).^2+d.divergence.^2+d.stretch.^2+d.shear.^2)/2;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function defo = getDefo(uvg);dF
    meanin4d = @(A,B) squeeze(mean([permute(A,[4,1,2,3]);permute(B,[4,1,2,3])],1));
    defo.vorticity = uvg.dVdx - uvg.dUdy;
    defo.shear = uvg.dVdx + uvg.dUdy;
    defo.divergence = 0;
    defo.stretch = - 2* meanin4d(uvg.dVdy,uvg.dUdx);
    %     defo.divergence = uvg.dUdx + uvg.dVdy;
    %     defo.stretch = uvg.dUdx - uvg.dVdy;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function uvg = UVgrads(UV,dx,dy,f);dF
    dd.y= @(in)  diff(in,1,2);
    dd.x= @(in)  diff(in,1,3);
    z=size(UV.u,1);
    uvg.dUdy = inxOry(dd.y(UV.u),'y',dy,z,f);
    uvg.dUdx = inxOry(dd.x(UV.u),'x',dx,z,f);
    uvg.dVdy = inxOry(dd.y(UV.v),'y',dy,z,f);
    uvg.dVdx = inxOry(dd.x(UV.v),'x',dx,z,f);
end
function out=inxOry(in,inxy,dxy,z,f);dF
    denom=f(dxy,z);
    if     strcmp(inxy,'y')
        out=in( :,[1:end, end], : )./ denom;
    elseif strcmp(inxy,'x')
        out= in(:, :,[1:end, end])./ denom;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function UV = getVels(my,f);dF
    rhoRef = 1000;
    dRho = getDrhodx(my,f);
    [Y,X]=size(my.dx);
    gzOverRhoF = my.GOverF .* repmat(my.depth,[1,Y,X]) / rhoRef;
    UV.u = -dRho.dy .* gzOverRhoF;
    UV.v = dRho.dx .*  gzOverRhoF;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dRho = getDrhodx(my,f);dF
    %% calc density gradients
    drdx = diff(my.rhoHighPass,1,3);
    drdy = diff(my.rhoHighPass,1,2);
    dRho.dx = drdx(:,:,[1:end, end]) ./ f(my.dx,my.Z);
    dRho.dy = drdy(:,[1:end, end],:) ./ f(my.dy,my.Z);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initOWNcFile(fname,toAdd,WinSize);dF
    nc_create_empty(fname,'clobber');
    nc_adddim(fname,'k_index',WinSize(1));
    nc_adddim(fname,'i_index',WinSize(3));
    nc_adddim(fname,'j_index',WinSize(2));
    %%
    for kk=1:numel(toAdd)
        ta=toAdd{kk};
        varstruct.Name = ta;
        varstruct.Nctype = 'single';
        varstruct.Dimension = {'k_index','j_index','i_index' };
        nc_addvar(fname,varstruct)
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%