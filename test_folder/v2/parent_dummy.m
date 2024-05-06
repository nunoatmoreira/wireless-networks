classdef parent_dummy < handle
    
    properties
        list;
        queue;
    end
    
    methods

        function obj = parent_dummy()
            list = [];
            queue = [];
        end
        
        function obj = addNode(parent_dummy)
            
            obj = parent_dummy;

            node = dummy_class(obj);
            
            obj.list = [obj.list; node];

        end

        function obj = addQueueEntry(parent_dummy, val)
            
            obj = parent_dummy;

            obj.queue = [obj.queue; val];
        end
    end
end

