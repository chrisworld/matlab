function [res_vector, best_fset] = H6_SFFS
% Sequential Forward Floating Search Feature selection

%% loading data for the exercise
load H6_data

% Vector of used features
fvector = zeros(1,size(data, 2)); %feature vector
% How many features we are going to take (can be changed to any number
% depending on the problem
max_n_features = 13; % dimension limit

% Initial dimension is one
n_features = 1;
best_result = 0;
res_vector = zeros(1,max_n_features); 

% forwards when 0, backwards when 1
search_direction = 0; 

% k-NN
k = 1;

%% loop
while(n_features <= max_n_features)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Step 1: Inclusion
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Search for the best feature vector forwards
    [best_result_add, best_feature_add] = ...
        findbest(data, data_c, fvector, search_direction, k);
    
    % Update the feature vector  
    fvector(best_feature_add) = 1;
    
    % check if result is better, save best result
    if(best_result < best_result_add)
        best_result = best_result_add;
        best_fset = fvector;
    end
    
    % Sometimes we might come back to the same number of selected 
    % features. So, if the accuracy is better in the case when we came
    % back, then we will update the vector of results.
    if(best_result_add > res_vector(n_features))
        res_vector(n_features) = best_result_add;
    end
    
    % print current result
    disp([res_vector(n_features), n_features])
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Step 2: Exclusion
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    search_direction = 1;
    while search_direction
        % If the number of selected features is greater than 2, we try 
        % to remove one the features. In the case when the number of
        % selected features is less than 2, we will go back to the
        % inclusion step
        
        if(n_features > 2)
            % remove one of the features. 
            % Search for the worst feature
            [best_result_rem, best_feature_rem] = ...
                findbest(data, data_c, fvector, search_direction, k);
            % If better than before, step backwards and update results
	        % otherwise we will go to the inclusion step
            if(best_result_rem > res_vector(n_features - 1))
                fvector(best_feature_rem) = 0;
                n_features = n_features - 1;
                if(best_result < best_result_rem)
                    best_result = best_result_rem;
                    best_fset = fvector;
                end
                
                res_vector(n_features) = best_result_rem;
                %print current result  
                disp([res_vector(n_features), n_features])
            else
                search_direction = 0;
            end
        else
            % In the case when the number of selected features is 
            % less than 2, we will go back to the inclusion step
            search_direction = 0;
        end
    end
    n_features = n_features+1;
end

figure
plot(res_vector)
xlabel('Number of Features Used')
ylabel('Classification Accuracy Achieved')
title('Sequential Forward Floating Search Feature Selection')
grid on
%axis([0 max_n_features 0 1.00])

res_vector
best_fset
end

%% findbest
function [best, feature] = findbest(data, data_c, fvector, direction,k)

num_samples = length(data);
best = 0;
feature = 0;

if(direction == 0)
    for in = 1:length(fvector)
        if (fvector(in) == 0)
            fvector(in) = 1;
            % Classify using k-NN
            % Euclidean distance
            D = squareform( pdist( data(:,logical(fvector)) ) ); 
            
            [D, I]=sort(D, 1);
            I=I(1:k+1, :);
            labels = data_c( : )';
            if k == 1
                predictedLabels = labels( I(2, : ) )';
            else
                predictedLabels = mode( labels( I( 1+(1:k), : ) ), 1)';
            end
            correct = sum(predictedLabels == data_c);
            result = correct/num_samples;
            if(result > best)
                best = result;
                feature = in;
            end
            fvector(in) = 0;
        end
    end
else
    for in = 1:length(fvector)
        if (fvector(in) == 1)
             fvector(in) = 0;
            % Classify using k-NN
            % Euclidean distance
            D = squareform( pdist( data(:,logical(fvector)) ) ); 

            [D, I]=sort(D, 1);
            I=I(1:k+1, :);
            labels = data_c( : )';
            if k == 1
                predictedLabels = labels( I(2, : ) )';
            else
                predictedLabels = mode( labels( I( 1+(1:k), : ) ), 1)';
            end
            correct = sum(predictedLabels == data_c);
            result = correct/num_samples;
            if(result > best)
                best = result;
                feature = in;
            end
            fvector(in) = 1;
        end
    end
end
end
