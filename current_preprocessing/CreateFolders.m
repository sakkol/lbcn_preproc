function CreateFolders(sbj_name, project_name, block_name, center, dirs, data_format,import_server)
%% Create folders LBCN

% Get generic name without lower case to match the server
% if isstrprop(sbj_name(end),'lower')
%     sbj_name_generic = sbj_name(1:end-1);
% else
%     sbj_name_generic = sbj_name;
% end
% 
% --
sbj_name_generic = sbj_name;


folder_names = {'originalData'};
folder_sublayers={'SpecData', 'BandData'};
% Subject folder name
if import_server
    all_folders = dir(fullfile('/Volumes/neurology_jparvizi$/'));
    for i = 1:length(all_folders)
        tpm(i) = contains(all_folders(i).name, sbj_name_generic);
    end
    sbj_folder_name = all_folders(find(tpm == 1)).name;
end

for i = 1:length(folder_sublayers)
    foldersublayers.(folder_sublayers{i}) = sprintf('%s/%s/%s',dirs.data_root,folder_sublayers{i});
    if ~exist(foldersublayers.(folder_sublayers{i}))
        mkdir(foldersublayers.(folder_sublayers{i}));
    end
end


%% Per subject
for i = 1:length(folder_names)
    folders.(folder_names{i}) = sprintf('%s/%s/%s',dirs.data_root,folder_names{i},sbj_name);
end
folders.psych_dir = sprintf('%s/%s',dirs.psych_root,sbj_name);
folders.result_dir = sprintf('%s/%s/%s',dirs.result_root,project_name,sbj_name);
folders.CARData = sprintf('%s/CARData/CAR/%s',dirs.data_root,sbj_name);

fieldname_folders = fieldnames(folders);

for i = 1:length(fieldname_folders)
    if ~exist(folders.(fieldname_folders{i}))
        mkdir(folders.(fieldname_folders{i}));
    end
end

%% --


for bn = 1:length(block_name)
    
    %     %% Check if the globalval.mat exist
    %     globalVar_file = sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_name{bn});
    %
    %     if exist(globalVar_file, 'file') >= 1
    %         prompt = ['subjVar already exist for ' sbj_name ' . Load and replace it? (y or n):'] ;
    %         ID = input(prompt,'s');
    %         if strcmp(ID, 'y')
    %             disp(['globalVar loaded for ' sbj_name])
    %         else
    %             warning(['subjVar NOT loaded ' sbj_name])
    %         end
    %     else
    %     end
    
    %% Per block - create folders and globalVar
    globalVar.block_name = block_name{bn};
    globalVar.sbj_name = sbj_name;
    globalVar.project_name = project_name;
    globalVar.center = center;
    %%
    for i = 1:length(folder_sublayers)
        globalVar.(folder_sublayers{i})=foldersublayers.(folder_sublayers{i});
    end
    
    %%
    for i = 1:length(fieldname_folders)
        globalVar.(fieldname_folders{i}) = [folders.(fieldname_folders{i}) '/' block_name{bn}];
        if ~exist(globalVar.(fieldname_folders{i}))
            mkdir(globalVar.(fieldname_folders{i}));
        end
        if strcmp(fieldname_folders{i}, 'psych_dir') || strcmp(fieldname_folders{i}, 'result_dir') || strcmp(fieldname_folders{i}, 'originalData')
        else
            if ~exist([globalVar.(fieldname_folders{i}) ])
                mkdir([globalVar.(fieldname_folders{i}) ]);
            end
        end
    end
    %% Original folders from the server
    % iEEG data
    if strcmp(import_server, 'auto') == 1
        if strcmp(project_name, 'SevenHeaven')
            project_name_server = '7Heaven';
        else
            project_name_server = project_name;
        end
        %iEEG file
        block_folder = sprintf('%s/%s/Data/%s/%s/',dirs.server_root, sbj_folder_name, project_name_server, block_name{bn});
        globalVar.iEEG_data_server_path = sprintf('%s%s.edf',block_folder,block_name{bn});
        disp(sprintf('identified iEEG file %s', globalVar.iEEG_data_server_path));
        
        % Behavior file
        files = dir(fullfile(block_folder));
        for i = 1:length(files)
            mat_idx(i) = contains(files(i).name, '.mat');
        end
        globalVar.behavioral_data_server_path = sprintf('%s%s',block_folder,files(mat_idx).name);
        disp(sprintf('identified behavior file %s', globalVar.behavioral_data_server_path));
        
        
    else
        
        if strcmp(project_name, 'Rest')
            if strcmp(data_format, 'edf')
                globalVar.iEEG_data_server_path = ['/Volumes/neurology_jparvizi$/' sbj_folder_name filesep 'Data/Rest/' [block_name{bn} '.edf']];
            elseif strcmp(data_format, 'TDT')
                globalVar.iEEG_data_server_path = ['/Volumes/neurology_jparvizi$/' sbj_folder_name filesep 'Data/Rest/' block_name{bn} filesep];
            end
            
        elseif strcmp(project_name, 'Rest_pupil')
            if strcmp(data_format, 'edf')
                globalVar.iEEG_data_server_path = ['/Volumes/neurology_jparvizi$/' sbj_folder_name filesep 'Data/Rest_pupil/' block_name{bn} filesep [block_name{bn} '.edf']];
            elseif strcmp(data_format, 'TDT')
                globalVar.iEEG_data_server_path = ['/Volumes/neurology_jparvizi$/' sbj_folder_name filesep 'Data/Rest_pupil/'  block_name{bn} filesep];
            end
        else
            
            if import_server == 1
                if strcmp(data_format, 'TDT')
                    waitfor(msgbox(['Choose server folder for iEEG data of block ' block_name{bn}]));
                    globalVar.iEEG_data_server_path = [uigetdir(['/Volumes/neurology_jparvizi$/' sbj_folder_name]) '/'];
                elseif strcmp(data_format, 'edf')
                    waitfor(msgbox(['Choose server file for iEEG data of block ' block_name{bn}]));
                    [FILENAME, PATHNAME] = uigetfile(['/Volumes/neurology_jparvizi$/' sbj_folder_name,'.edf'],'All Files (*.*)','MultiSelect','on');
                    globalVar.iEEG_data_server_path = [PATHNAME, FILENAME];
                else
                end
                if ~contains(project_name, 'Rest')
                    % Behavioral data
                    waitfor(msgbox(['Choose file of the behavioral data on the server for block ' block_name{bn}]));
                    [FILENAME, PATHNAME] = uigetfile(['/Volumes/neurology_jparvizi$/' sbj_folder_name]);
                    globalVar.behavioral_data_server_path = [PATHNAME, FILENAME];
                else
                end
            end
            
        end
        
    end
    
    % Save globalVariable
    fn = [folders.originalData '/' sprintf('global_%s_%s_%s.mat',project_name,sbj_name,block_name{bn})];
    save(fn,'globalVar');
end

end




