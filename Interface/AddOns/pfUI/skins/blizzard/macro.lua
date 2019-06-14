pfUI:RegisterSkin("Macro", "vanilla", function ()
  local border = tonumber(pfUI_config.appearance.border.default)
  local bpad = border > 1 and border - 1 or 1

  HookAddonOrVariable("Blizzard_MacroUI", function()
    StripTextures(MacroFrame)
    CreateBackdrop(MacroFrame, nil, nil, .75)
    CreateBackdropShadow(MacroFrame)

    MacroFrame.backdrop:SetPoint("TOPLEFT", 10, -10)
    MacroFrame.backdrop:SetPoint("BOTTOMRIGHT", -32, 72)
    MacroFrame:SetHitRectInsets(10,32,10,72)
    EnableMovable(MacroFrame)

    SkinCloseButton(MacroFrameCloseButton, MacroFrame.backdrop, -6, -6)

    local MacroFrameHeaderText = GetNoNameObject(MacroFrame, "FontString", "BORDER", CREATE_MACROS)
    MacroFrameHeaderText:ClearAllPoints()
    MacroFrameHeaderText:SetPoint("TOP", MacroFrame.backdrop, "TOP", 0, -10)

    SkinTab(MacroFrameTab1)
    SkinTab(MacroFrameTab2)
    MacroFrameTab2:ClearAllPoints()
    MacroFrameTab2:SetPoint("LEFT", MacroFrameTab1, "RIGHT", border*2 + 1, 0)

    for i=1, MAX_MACROS do
      local button = _G["MacroButton"..i]
      local icon = _G["MacroButton"..i..'Icon']
      StripTextures(button)
      SkinButton(button, nil, nil, nil, icon)
      button:SetCheckedTexture([[Interface\Buttons\CheckButtonHilight]])
    end
    StripTextures(MacroFrameSelectedMacroButton)
    SkinButton(MacroFrameSelectedMacroButton, nil, nil, nil, MacroFrameSelectedMacroButtonIcon, true)
    MacroFrameSelectedMacroName:ClearAllPoints()
    MacroFrameSelectedMacroName:SetPoint("TOPLEFT", MacroFrameSelectedMacroButton, "TOPRIGHT", 6, 3)

    SkinButton(MacroEditButton)
    SkinButton(MacroDeleteButton)
    SkinButton(MacroExitButton)
    SkinButton(MacroNewButton)
    MacroNewButton:ClearAllPoints()
    MacroNewButton:SetPoint("RIGHT", MacroExitButton, "LEFT", -2*bpad, 0)

    MacroEditButton:SetHeight(22)
    MacroEditButton:SetWidth(150)
    MacroEditButton:ClearAllPoints()
    MacroEditButton:SetPoint("BOTTOMLEFT", MacroFrameSelectedMacroButton, "BOTTOMRIGHT", 6, -2)

    MacroFrameEnterMacroText:ClearAllPoints()
    MacroFrameEnterMacroText:SetPoint("BOTTOMLEFT", MacroFrameTextBackground, "TOPLEFT", 8, 2)

    CreateBackdrop(MacroFrameTextBackground, nil, true)
    MacroFrameTextBackground:ClearAllPoints()
    MacroFrameTextBackground:SetPoint("TOPLEFT", MacroFrame, "TOPLEFT", 18, -300)
    StripTextures(MacroFrameScrollFrame)
    SkinScrollbar(MacroFrameScrollFrameScrollBar)
    MacroFrameScrollFrame:ClearAllPoints()
    MacroFrameScrollFrame:SetPoint("TOPLEFT", MacroFrameSelectedMacroBackground, "BOTTOMLEFT", 11, -13)



    StripTextures(MacroPopupFrame)
    CreateBackdrop(MacroPopupFrame, nil, nil, .75)
    MacroPopupFrame:SetFrameStrata("DIALOG")
    MacroPopupFrame:ClearAllPoints()
    MacroPopupFrame:SetPoint("TOPLEFT", MacroFrame.backdrop, "TOPRIGHT", 2*border, 0)

    StripTextures(MacroPopupScrollFrame)
    SkinScrollbar(MacroPopupScrollFrameScrollBar)

    MacroPopupEditBox:DisableDrawLayer("BACKGROUND")
    CreateBackdrop(MacroPopupEditBox, nil, true)
    MacroPopupEditBox:SetScript("OnEscapePressed", function()
      MacroPopupFrame:Hide()
      MacroFrame_Update()
    end)

    for i=1, NUM_MACRO_ICONS_SHOWN do
      local button = _G["MacroPopupButton"..i]
      local icon = _G["MacroPopupButton"..i..'Icon']
      StripTextures(button)
      SkinButton(button, nil, nil, nil, icon)
      button:SetCheckedTexture([[Interface\Buttons\CheckButtonHilight]])
    end
    SkinButton(MacroPopupCancelButton)
    SkinButton(MacroPopupOkayButton)
    MacroPopupOkayButton:ClearAllPoints()
    MacroPopupOkayButton:SetPoint("RIGHT", MacroPopupCancelButton, "LEFT", -2*bpad, 0)
  end)
end)
