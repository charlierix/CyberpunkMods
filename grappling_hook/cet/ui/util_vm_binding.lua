-- This gets called when an up/down button gets pressed.  It updates the corresponding
-- property and adjusts experience (models aren't directly updated immediately, values
-- are stored in changes, giving the user the option to Ok or Cancel)
--
-- Params
--  property_name       the property to store in changes (which references a property in the model)
--  experience_name     in most cases, it's "experience"
--  isDownClicked       true if they clicked the down button
--  isUpClicked         true if they clicked the up button
--  def                 models\viewmodels\UpDownButtons
--  changes             an instance of Changes
function Update_UpDownButton(property_name, experience_name, isDownClicked, isUpClicked, def, changes)
    if isDownClicked and def.isEnabled_down then
        changes:Subtract(property_name, def.value_down)

        if not def.isFree_down then
            changes:Add(experience_name, 1)
        end
    end

    if isUpClicked and def.isEnabled_up then
        changes:Add(property_name, def.value_up)

        if not def.isFree_up then
            changes:Subtract(experience_name, 1)
        end
    end
end