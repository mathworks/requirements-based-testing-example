classdef WindowFcns < handle
    %%
    % Class for image based verification and validation
    %
    % All properties are read-only, set through methods
    % 
       
    properties (SetAccess = private, GetAccess = private)

    end 
    
    properties (SetAccess = private, GetAccess = public)
        % status for loading of external user32.dll
        extLibLoaded = false;
        % status for setting pixel coordinates of window for analysis
        winPosSet = false;
        % analysis window frame coordinates as a java.awt.Rectangle object
        RECT_Window = [];
    end
    
    methods (Access = private)
        
        function [success] = loadLibrary(WF)
            % loads "user32.dll" for access to required windows functions, called from constructor
            if ~libisloaded('user32')
                try
                    evalin('base','loadlibrary(''user32.dll'',''user32WindowFcns.h'');');
                    WF.extLibLoaded  = true;
                catch
                    % add error message
                end
            end
            WF.extLibLoaded = libisloaded('user32');
            success = WF.extLibLoaded;
        end
       
        function [success] = unloadLibrary(WF)
            % unloads "user32.dll" for access to required windows functions, called from destructor
            if libisloaded('user32')
                evalin('base','unloadlibrary(''user32'');');
            end
            WF.extLibLoaded = libisloaded('user32');
            if ~WF.extLibLoaded
                WF.winPosSet   = false;
            end
            success = ~WF.extLibLoaded;
        end
        
   end
    
   methods (Access = public)
        
        function WF = WindowFcns()
            % creates object for screen capture analysis and loads "user32.dll" library when successful
            if ~WF.loadLibrary()
               WF.delete();
            end
        end
        
        function delete(WF)
            % deletes the object and unloads "user32.dll"
            WF.unloadLibrary();
        end 
        
        function [success] = setWinPosByName(WF,winName,x,y,width,height)
            success = false;
            if ~WF.extLibLoaded 
                return;
            end
            [success, pHandle] = WF.getWinHandle(winName);
            if ~success
                return;
            end
            winSettingPtr = libpointer('voidPtr');
            if ~calllib('user32','SetWindowPos',pHandle, ...
                    winSettingPtr,x,y,width,height,64);
            else
                success = WF.getWinPosWithHandle(pHandle);
            end
            clear winSettingPtr;
            clear pHandle;
            WF.winPosSet = (success==1);
        end
        
    end
       
     
    methods (Access = private)

        function [success, pHandle] = getWinHandle(~,winName)
            pHandle = calllib('user32','FindWindowA',[],winName);
            success = (~pHandle.isNull);
        end
        
        function [success] = getWinPosWithHandle(WF,pHandle)
            
            success = false;
            % show window in normal mode
            if ~calllib('user32','ShowWindow',pHandle,int32(1))
                return;
            end
            % create struct that matches RECT struct definition         
            RECT = struct('left', int32(0), 'top',   int32(0), ...
              'right',int32(0), 'bottom',int32(0));
            % use type (s_RECT) as shown in libfunctionsview ('user32')           
            pRECT_Window = libstruct('s_RECT',RECT);
            % get coordinates of window
            if ~calllib('user32','GetWindowRect',pHandle,pRECT_Window)
                return;
            end
            
            import java.awt.Rectangle
            
            WF.RECT_Window           = Rectangle;                   
            WF.RECT_Window.x         = pRECT_Window.left;
            WF.RECT_Window.width     = pRECT_Window.right - pRECT_Window.left;
            WF.RECT_Window.y         = pRECT_Window.top;
            WF.RECT_Window.height    = pRECT_Window.bottom - pRECT_Window.top;

            success = true;
            % delete associated user32 library objects
            clear pRECT_Window;

        end

    end
   
end

