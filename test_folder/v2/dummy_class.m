classdef dummy_class < handle

    properties
        parent;
        t;
        counter;
    end
    
    methods
        function obj = dummy_class(parent)
            obj.parent = parent;

            obj.counter = 0;
            
            obj.t = timer;
            
            obj.t.TimerFcn = @obj.updateVar;
            obj.t.Period = 5;
            obj.t.StartDelay = 0;
            obj.t.ExecutionMode = 'fixedSpacing';
            
            start(obj.t);
        end
        
        function obj = updateVar(dummyClass, ~, ~)
            
            obj = dummyClass;

            obj.counter = [obj.counter; obj.counter(end)+1];

            obj.parent = obj.parent.addQueueEntry(obj.counter(end));
            
            disp(string(obj.counter(end)));
        end
    end
end

