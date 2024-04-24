classdef SIM_DATA
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id;
        distance = [];
        link_budget = [];
        prop_delay = [];
        doppler = [];
        time = [];
        counter = 0;
    end
    
    methods

        function obj = SIM_DATA(id)
            obj.id = id;
            obj.distance = [];
            obj.link_budget = [];
            obj.prop_delay = [];
            obj.doppler = [];
            obj.time = [];
            obj.counter = 0;
        end

    end
end

