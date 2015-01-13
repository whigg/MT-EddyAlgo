%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created: 22-Sep-2014 18:33:55
% Computer:  GLNXA64
% Matlab:  8.1
% Author:  NK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sub09_trackinit(DD)
    
    senses.t=fieldnames(DD.path.analyzedTracks)';
    senses.s=DD.FieldKeys.senses;
    %%
    for ss=1:2
        [sense,root,eds,toLoad]=inits(DD,senses,ss);
        %%
        single=sPmDstoof(DD,eds,root,toLoad);
        %%
        cats=buildOutStruct(single);
        %%
        cats.vel=makeVel(cats);
        %%
        saveCats(cats,sense);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sense,root,eds,toLoad]=inits(DD,senses,ss)
    sense.t=senses.t{ss};
    sense.s=senses.s{ss};
    root=DD.path.analyzedTracks.(sense.t).name;
    eds= DD.path.analyzedTracks.(sense.t).files;
    tl={'radiusmean'; 'lat'; 'lon'; 'velPP'; 'age';'cheltareaLe';'cheltareaLeff';'cheltareaL';'trackreflin'};
    toLoad(numel(tl)).name=struct;
    [toLoad(:).name] = deal(tl{:});
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sngl=sPmDstoof(DD,eds,root,toLoad)
    JJ=thread_distro(DD.threads.num,numel(eds));
    spmd(DD.threads.num)
        FF=JJ(labindex,1):JJ(labindex,2);
        T=disp_progress('init','blubb');
        for ff=1:numel(FF)
            T=disp_progress('calc',T,diff(JJ(labindex,:))+1,100);
            currFile = [root eds(FF(ff)).name];
            sngl(ff)=load(currFile,toLoad(:).name);
        end
        sngl=gcat(sngl,2,1);
    end
    sngl=sngl{1};
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cats=buildOutStruct(single)
    for fn=fieldnames(single)'; fn=fn{1};
        cats.(fn)=extractdeepfield(single,fn);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function vel=makeVel(cats)
    cc=0;
    for ff=1:numel(cats.velPP)
        pp=cats.velPP{ff};
        if isempty(pp)
            continue
        end
        cc=cc+1;
        vel{ff}=ppval(pp.x_t,pp.timeaxis);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function saveCats(cats,sense)
   area2L=@(ar) sqrt(ar/pi);
    tmp=cats.radiusmean;         %#ok<*NASGU>
    save(['TR-' sense.s '-rad.mat'],'tmp')
    tmp=area2L(cats.cheltareaLe);
    save(['TR-' sense.s '-radLe.mat'],'tmp')
    tmp=area2L(cats.cheltareaL);
    save(['TR-' sense.s '-radL.mat'],'tmp')
    tmp=area2L(cats.cheltareaLeff);
    save(['TR-' sense.s '-radLeff.mat'],'tmp')
    tmp=cats.age;
    save(['TR-' sense.s '-age.mat'],'tmp')
    tmp=cats.lat;
    save(['TR-' sense.s '-lat.mat'],'tmp')
    tmp=cats.lon;
    save(['TR-' sense.s '-lon.mat'],'tmp')
    tmp=cats.vel;
    save(['TR-' sense.s '-vel.mat'],'tmp')
    tmp=cats.trackreflin;
    save(['TR-' sense.s '-reflin.mat'],'tmp')
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%










