local mouseX, mouseY, x, y, dx, dy, w, h = 0, 0, 25, 660, 0, 0, 300, 60;
local shouldDrag = false;
local font_title = draw.CreateFont("Arial", 16, 16);
local topbarSize = 25;


local render = {};

render.outline = function( x, y, w, h, col )
	draw.Color( col[1], col[2], col[3], col[4] );
	draw.OutlinedRect( x, y, x + w, y + h );
end

render.rect = function( x, y, w, h, col )
	draw.Color( col[1], col[2], col[3], col[4] );
	draw.FilledRect( x, y, x + w, y + h );
end

render.rect2 = function( x, y, w, h )
	draw.FilledRect( x, y, x + w, y + h );
end

render.gradient = function( x, y, w, h, col1, col2, is_vertical )
	render.rect( x, y, w, h, col1 );

	local r, g, b = col2[1], col2[2], col2[3];

	if is_vertical then
		for i = 1, h do
			local a = i / h * 255;
			render.rect( x, y + i, w, 1, { r, g, b, a } );
		end
	else
		for i = 1, w do
			local a = i / w * 255;
			render.rect( x + i, y, 1, h, { r, g, b, a } );
		end
	end
end

local function getKeybinds()
local fakedeuck = gui.GetValue("rbot_antiaim_fakeduck");
local slowwalk = gui.GetValue("msc_slowwalk");
local edgejump = gui.GetValue("msc_edgejump");

local Doubletap = gui.GetValue("rbot_doublefire");
local ThirdPerson = gui.GetValue("vis_thirdperson_dist");

    local Keybinds = {};
	local i = 1;
	if   gui.GetValue("rbot_active") and gui.GetValue("rbot_antiaim_enable") and fakedeuck ~= 0 and input.IsButtonDown(fakedeuck)  then
    	Keybinds[i] = '[Fake duck]';
        i = i + 1;
     end
	 	if  slowwalk ~= 0 and input.IsButtonDown(slowwalk)  then
    	Keybinds[i] = '[Slow Walk]';
        i = i + 1;
     end
	 	if  edgejump ~= 0 and input.IsButtonDown(edgejump)  then
    	Keybinds[i] = '[Edge Jump]';
        i = i + 1;
     end
	 	if  gui.GetValue("rbot_active") and Doubletap  then
    	Keybinds[i] = '[Double Tap]';
        i = i + 1;
     end
     if gui.GetValue("esp_active") and ThirdPerson > 50  then
    	Keybinds[i] = '[Third Person]';
        i = i + 1;
     end

     if   gui.GetValue("rbot_active") and gui.GetValue("rbot_delayshot") ~= 0  then
    	Keybinds[i] = '[Delay Shot]';
        i = i + 1;
     end
	 if   gui.GetValue("msc_fakelag_enable") and gui.GetValue("msc_fakelag_key")~= 0  and input.IsButtonDown(gui.GetValue("msc_fakelag_key")) then
    	Keybinds[i] = '[Fake Lag]';
        i = i + 1;
     end
	 	 if  gui.GetValue("rbot_active") and gui.GetValue("rbot_resolver_override")~= 0 and input.IsButtonDown(gui.GetValue("rbot_resolver_override")) then
    	Keybinds[i] = '[Override Resolver]';
        i = i + 1;
     end
    return Keybinds;
end

local function drawRectFill(r, g, b, a, x, y, w, h, texture)
    if (texture ~= nil) then
        draw.SetTexture(texture);
    else
        draw.SetTexture(r, g, b, a);
    end
    draw.Color(r, g, b, a);
    draw.FilledRect(x, y, x + w, y + h);
end

local function drawGradientRectFill(col1, col2, x, y, w, h)
    drawRectFill(col1[1], col1[2], col1[3], col1[4], x, y, w, h);
    local r, g, b = col2[1], col2[2], col2[3];
    for i = 1, h do
        local a = i / h * col2[4];
        drawRectFill(r, g, b, a, x + 2, y + i, w - 2, 1);
    end
end

local function dragFeature()
    if input.IsButtonDown(1) then
        mouseX, mouseY = input.GetMousePos();
        if shouldDrag then
            x = mouseX - dx;
            y = mouseY - dy;
        end
        if mouseX >= x and mouseX <= x + w and mouseY >= y and mouseY <= y + 40 then
            shouldDrag = true;
            dx = mouseX - x;
            dy = mouseY - y;
        end
    else
        shouldDrag = false;
    end
end

local function drawOutline(r, g, b, a, x, y, w, h, howMany)
    for i = 1, howMany do
        draw.Color(r, g, b, a);
        draw.OutlinedRect(x - i, y - i, x + w + i, y + h + i);
    end
end

local function drawWindow(Keybinds)
    local h2 = 10 + (Keybinds * 15);
    local h = h + (Keybinds * 15);

    drawRectFill(27, 24, 25, 255, x + 7, y + 10, 216, 20);
    drawOutline(41, 35, 36, 255, x + 7, y  + 10, 216, 20, 2);

    render.gradient( x + 5, y + 8, 127, 4, { 59, 175, 222, 255 }, { 202, 70, 205, 255 }, false );
	render.gradient( x + 133, y + 8, 180 / 2, 4, { 202, 70, 205, 255 }, { 201, 227, 58, 255 }, false );
    draw.Color(153, 204, 0);
    draw.SetFont(font_title);
    local keytext = 'Keybinds';
    local tW, _ = draw.GetTextSize(keytext);
    draw.Text(x + ((230 - tW) / 2), y + 12, keytext)


    drawRectFill(27, 24, 25, 255, x + 7, y + 40, 216, h2);

    drawOutline(41, 35, 36, 255, x + 7, y + 40, 216, h2, 2);
	
	render.gradient( x + 6, y + h - 7, 127, 4, { 59, 175, 222, 255 }, { 202, 70, 205, 255 }, false );
	render.gradient( x + 133,  y + h - 7 , 180 / 2, 4, { 202, 70, 205, 255 }, { 201, 227, 58, 255 }, false );
	
end

local function drawindicators(Keybinds)
    for index, keys in pairs(Keybinds) do
        draw.Color(255, 255, 255, 255);
        draw.Text(x + 15, (y + topbarSize + 5) + (index * 15), keys)
		draw.Text(x + 170, (y + topbarSize + 5) + (index * 15), '[Active]')
    end
end

callbacks.Register("Draw", function()

    local Keybinds = getKeybinds();
	 local lp = entities.GetLocalPlayer();
    if lp == nil then
	return
	end
   if (#Keybinds == 0) then
        return
    end
    drawWindow(#Keybinds);
    drawindicators(Keybinds);
    dragFeature();
end)
