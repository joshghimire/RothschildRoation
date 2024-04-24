%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function:i) filters the signal at each trial with 60 Hz notch
%               ii) morlet wavelet for each trial
%               iii) returns the abs. value average and average of all
%               trials
% useful for basic pop. analysis 
% HK 01/10/2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [isi_20, isi_40, isi_60, isi_80, isi_100, isi_120, isi_160, isi_200, trial_num] = avt_mag_sestrial(filename, f_index)

  [mlf_pref mlf_null mev_pref mev_null]=splt_evt_lfpall(filename);
  plot_time_st=0;
  fs=1000;
  f = 1:50;

  for cond_no=1:8,

    if (mod(cond_no-1,8) < 6),
       remain=0; 
    else
       remain=mod(cond_no-1,8)-5;
    end;
    offset=330+40*mod(cond_no-1,8)+40*remain;
    plot_time_fn=offset+200;
    num_points=plot_time_fn-plot_time_st;
    
    [lfptimes_pref, lfpvalues_pref, lfptimes_null, lfpvalues_null, conditions1, total_trial_num]=avt_mean_lfp(filename, mlf_pref, mlf_null, mev_pref, mev_null, plot_time_st, cond_no);
     
    [x_time trial_num aud_cond]= size (lfpvalues_pref);
    for j = 1: aud_cond,
        for i = 1: trial_num,
         
         filtered_pref=mynotch(lfpvalues_pref(:,i,j));
         filtered_null=mynotch(lfpvalues_null(:,i,j));
         if (f_index==1),
             c_lfppref(:,:,i,j) = cmorTransSpec(filtered_pref, fs, f, 1, -1);
             c_lfpnull(:,:,i,j) = cmorTransSpec(filtered_null, fs, f, 1, -1);
         else
             c_lfppref(:,:,i,j) = cmorTransSpec(filtered_null, fs, f, 1, -1);
             c_lfpnull(:,:,i,j) = cmorTransSpec(filtered_pref, fs, f, 1, -1);
         end;
         
        end;
    end;
    
    phase_coh_pref=c_lfppref;
    phase_coh_null=c_lfpnull;
    non_index1= (abs(c_lfppref)~=0);
    non_index2= (abs(c_lfpnull)~=0);
    phase_coh_pref(non_index1)=c_lfppref(non_index1)./abs(c_lfppref(non_index1));
    phase_coh_null(non_index2)=c_lfpnull(non_index2)./abs(c_lfpnull(non_index2));
    ses_max=max(max(max(max(max(abs(c_lfppref))))), max(max(max(max(abs(c_lfpnull))))));
    
    c_lfppref=c_lfppref/ses_max;
    c_lfpnull=c_lfpnull/ses_max;
    
    switch(cond_no)
        case 1
           isi_20(:,:,1,:,1)=sum(c_lfppref, 3);
           isi_20(:,:,2,:,1)=sum(abs(c_lfppref),3);
           isi_20(:,:,3,:,1)=sum(phase_coh_pref, 3);
           isi_20(:,:,1,:,2)=sum(c_lfpnull, 3);
           isi_20(:,:,2,:,2)=sum(abs(c_lfpnull),3);
           isi_20(:,:,3,:,2)=sum(phase_coh_null, 3);
        case 2
           isi_40(:,:,1,:,1)=sum(c_lfppref, 3);
           isi_40(:,:,2,:,1)=sum(abs(c_lfppref),3);
           isi_40(:,:,3,:,1)=sum(phase_coh_pref, 3);
           isi_40(:,:,1,:,2)=sum(c_lfpnull, 3);
           isi_40(:,:,2,:,2)=sum(abs(c_lfpnull),3);
           isi_40(:,:,3,:,2)=sum(phase_coh_null, 3);   
        case 3
           isi_60(:,:,1,:,1)=sum(c_lfppref, 3);
           isi_60(:,:,2,:,1)=sum(abs(c_lfppref),3);
           isi_60(:,:,3,:,1)=sum(phase_coh_pref, 3);
           isi_60(:,:,1,:,2)=sum(c_lfpnull, 3);
           isi_60(:,:,2,:,2)=sum(abs(c_lfpnull),3);
           isi_60(:,:,3,:,2)=sum(phase_coh_null, 3);
        case 4
           isi_80(:,:,1,:,1)=sum(c_lfppref, 3);
           isi_80(:,:,2,:,1)=sum(abs(c_lfppref),3);
           isi_80(:,:,3,:,1)=sum(phase_coh_pref, 3);
           isi_80(:,:,1,:,2)=sum(c_lfpnull, 3);
           isi_80(:,:,2,:,2)=sum(abs(c_lfpnull),3);
           isi_80(:,:,3,:,2)=sum(phase_coh_null, 3);
        case 5
           isi_100(:,:,1,:,1)=sum(c_lfppref, 3);
           isi_100(:,:,2,:,1)=sum(abs(c_lfppref),3);
           isi_100(:,:,3,:,1)=sum(phase_coh_pref, 3);
           isi_100(:,:,1,:,2)=sum(c_lfpnull, 3);
           isi_100(:,:,2,:,2)=sum(abs(c_lfpnull),3);
           isi_100(:,:,3,:,2)=sum(phase_coh_null, 3);
        case 6
           isi_120(:,:,1,:,1)=sum(c_lfppref, 3);
           isi_120(:,:,2,:,1)=sum(abs(c_lfppref),3);
           isi_120(:,:,3,:,1)=sum(phase_coh_pref, 3);
           isi_120(:,:,1,:,2)=sum(c_lfpnull, 3);
           isi_120(:,:,2,:,2)=sum(abs(c_lfpnull),3);
           isi_120(:,:,3,:,2)=sum(phase_coh_null, 3);
        case 7
           isi_160(:,:,1,:,1)=sum(c_lfppref, 3);
           isi_160(:,:,2,:,1)=sum(abs(c_lfppref),3);
           isi_160(:,:,3,:,1)=sum(phase_coh_pref, 3);
           isi_160(:,:,1,:,2)=sum(c_lfpnull, 3);
           isi_160(:,:,2,:,2)=sum(abs(c_lfpnull),3);
           isi_160(:,:,3,:,2)=sum(phase_coh_null, 3);
        case 8
           isi_200(:,:,1,:,1)=sum(c_lfppref, 3);
           isi_200(:,:,2,:,1)=sum(abs(c_lfppref),3);
           isi_200(:,:,3,:,1)=sum(phase_coh_pref, 3);
           isi_200(:,:,1,:,2)=sum(c_lfpnull, 3);
           isi_200(:,:,2,:,2)=sum(abs(c_lfpnull),3);
           isi_200(:,:,3,:,2)=sum(phase_coh_null, 3);
    end;
    clear filtered_pref filtered null c_lfppref c_lfpnull ses_max phase_coh_pref;
    clear lfptimes_pref lfpvalues_pref lfptimes_null lfpvalues_null phase_coh_null;
  end;
         

    
    
         
         