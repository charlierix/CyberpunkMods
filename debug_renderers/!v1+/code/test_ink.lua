local this = {}

function this.GetInk_Canvas_ToDrawOn()
    -- find the code that gets the parent ink something to place buttons/text/graphics on

    --  Observe("hudCameraController", "OnInitialize", function (self) -- Modify camera HUD
    --      ui.hud = self
	--      if ui.drone.spawned then
	--      local rootWidget = self:GetRootCompoundWidget()

    -- GetRootCompoundWidget:
    --  public native class inkIGameController
    --      public native GetRootCompoundWidget(): inkCompoundWidget







    -- the find the most generic events that give access to that
end

function this.Extends_inkGameController()
   
    --Search "extends inkGameController" (88 hits in 64 files of 1489 searched)
    -- Line 2: public native class gameuiGenericNotificationGameController extends inkGameController {
    -- Line 2: public native class inkHUDGameController extends inkGameController {
    -- Line 2: public native class PhoneWaveformGameController extends inkGameController {
    -- Line 2: public class NetworkInkGameController extends inkGameController {
    -- Line 200: public class DeviceInkGameControllerBase extends inkGameController {
    -- Line 2: public class BrowserGameController extends inkGameController {
    -- Line 2: public class ControlledDevicesInkGameController extends inkGameController {
    -- Line 2: public class SceneScreenGameController extends inkGameController {

    -- Line 24: public class CustomAnimationsGameController extends inkGameController {
    -- Line 2: public class GenericMessageNotification extends inkGameController {
    -- Line 2: public native class HoldIndicatorGameController extends inkGameController {
    -- Line 2: public class TutorialMainController extends inkGameController {
    -- Line 94: public class CursorGameController extends inkGameController {

    -- Line 2: public class BackpackEquipSlotChooserPopup extends inkGameController {
    -- Line 2: public native class inkCooldownGameController extends inkGameController {
    -- Line 2: public class CraftingPopupController extends inkGameController {
    -- Line 2: public class CraftingSkillWidget extends inkGameController {
    -- Line 2: public class CyberwareAttributesSkills extends inkGameController {
    -- Line 2: public class FastTravelGameController extends inkGameController {
    -- Line 2: public class BaseHubMenuController extends inkGameController {
    -- Line 2: public class PauseMenuBackgroundGameController extends inkGameController {
    -- Line 2: public class CodexPopupGameController extends inkGameController {
    -- Line 2: public class PhoneMessagePopupGameController extends inkGameController {
    -- Line 2: public native class PopupsManager extends inkGameController {
    -- Line 2: public class ShardNotificationController extends inkGameController {
    -- Line 2: public native class gameuiPhotoModeMenuController extends inkGameController {
    -- Line 2: public native class gameuiPhotoModeStickersController extends inkGameController {
    -- Line 2: public class BoothModeGameController extends inkGameController {
    -- Line 2: public class PreGameSubMenuGameController extends inkGameController {
    -- Line 2: public class CyberwareMainGameController extends inkGameController {
    -- Line 2: public class TarotPreviewGameController extends inkGameController {
    -- Line 35: public class TimeMenuGameController extends inkGameController {
    -- Line 2: public class ItemQuantityPickerController extends inkGameController {
    -- Line 2: public class VendorConfirmationPopup extends inkGameController {
    -- Line 2: public class VendorSellJunkPopup extends inkGameController {
    -- Line 2: public class MessageCounterController extends inkGameController {
    -- Line 2: public class BaseChunkGameController extends inkGameController {
    -- Line 2: public class ScannerHintInkGameController extends inkGameController {
    -- Line 9: public class BaseModalListPopupGameController extends inkGameController {
    -- Line 2: public class LootingGameController extends inkGameController {
    -- Line 2: public class NetRunnerChargesGameController extends inkGameController {
    -- Line 2: public class StealthMappinGameController extends inkGameController {
    -- Line 22: public class buildsWidgetGameController extends inkGameController {
    -- Line 18: public class CpoCharacterSelectionWidgetGameController extends inkGameController {
    -- Line 2: public native class gameuiMenuGameController extends inkGameController {
    -- Line 2: public native class MinigameControllerAdvanced extends inkGameController {
    -- Line 44: public native class HackingMinigameGameController extends inkGameController {
    -- Line 2: public native class MinigameController extends inkGameController {
    -- Line 2: public native class TutorialPopupGameController extends inkGameController {
    -- Line 2: public class inkDexLimoGameController extends inkGameController {
    -- Line 9: public class vehicleVcarGameController extends inkGameController {
    -- Line 2: public native class gameuiCrosshairBaseGameController extends inkGameController {

    -- Line 2: public class KillMarkerGameController extends inkGameController {
    -- Line 96: public class megatronCrosshairGameController extends inkGameController {
    -- Line 2: public class blunderbussWeaponController extends inkGameController {
    -- Line 2: public class CpoHudRootGameController extends inkGameController {
    -- Line 2: public class TargetHitIndicatorGameController extends inkGameController {
    -- Line 2: public class cursorDeviceGameController extends inkGameController {

    -- Line 2: public class NewCodexEntryGameController extends inkGameController {
    -- Line 2: public class PhoneMessageNotificationsGameController extends inkGameController {
    -- Line 34638: public native class inkHUDGameController extends inkGameController {

    -- Line 52234: public native class gameuiMenuGameController extends inkGameController {
    -- Line 53553: public native class gameuiGenericNotificationGameController extends inkGameController {
    -- Line 54369: public native class gameuiCrosshairBaseGameController extends inkGameController {

    -- Line 54704: public native class gameuiIronsightGameController extends inkGameController {
    -- Line 55563: public native class gameuiBaseMenuGameController extends inkGameController {
    -- Line 56340: public native class gameuiGenericNotificationReceiverGameController extends inkGameController {
    -- Line 56434: public native class BaseGOGProfileController extends inkGameController {
    -- Line 56506: public native class MinigameController extends inkGameController {
    -- Line 69805: public native class PhoneWaveformGameController extends inkGameController {
    -- Line 70709: public native class HoldIndicatorGameController extends inkGameController {
    -- Line 71974: public native class inkCooldownGameController extends inkGameController {
    -- Line 72168: public native class gameuiCreditsController extends inkGameController {
    -- Line 74889: public native class PopupsManager extends inkGameController {
    -- Line 75293: public native class gameuiPhotoModeMenuController extends inkGameController {
    -- Line 75902: public native class gameuiPhotoModeStickersController extends inkGameController {
    -- Line 80546: public native class MinigameControllerAdvanced extends inkGameController {
    -- Line 80711: public native class HackingMinigameGameController extends inkGameController {
    -- Line 81456: public native class TutorialPopupGameController extends inkGameController {
    -- Line 82653: public class HUDButtonHints extends inkGameController {

    -- Line 82693: public native class InputHintManagerGameController extends inkGameController {
    -- Line 84965: public class FUNC_TEST_inkGameController extends inkGameController {

    -- Line 2: public class gameNotificationsTest extends inkGameController {
    -- Line 18: public class gameNotificationsReceiverTest extends inkGameController {
    -- Line 2: public class sampleStyleManagerGameController extends inkGameController {

    -- Line 39: public class sampleUIPathAndReferenceGameController extends inkGameController {
    -- Line 116: public class sampleStylesGameController extends inkGameController {
    -- Line 2: public class SampleUITextSystemController extends inkGameController {

end
function this.Extends_inkGameController_FurtherResearch()
    -- SceneScreenGameController extends inkGameController
    -- CursorGameController extends inkGameController
    -- gameuiCrosshairBaseGameController extends inkGameController
    -- cursorDeviceGameController extends inkGameController
    -- gameuiCrosshairBaseGameController extends inkGameController
    -- gameuiIronsightGameController extends inkGameController
    -- HUDButtonHints extends inkGameController
    -- FUNC_TEST_inkGameController extends inkGameController
    -- sampleStyleManagerGameController extends inkGameController
    -- sampleStylesGameController extends inkGameController



    -- inkHUDGameController extends inkGameController
    this.Extends_inkHUDGameController()

end

function this.Extends_inkHUDGameController()

    -- these seem to be all the overlays


    -- base class:
    -- inkHUDGameController extends inkGameController


    -- derived classes:
    -- public class activityLogGameController extends inkHUDGameController {
    -- public class CustomAnimationsHudGameController extends inkHUDGameController {
    -- public class BriefingScreen extends inkHUDGameController {

    -- public class hudCameraController extends inkHUDGameController {

    -- public class hudCorpoController extends inkHUDGameController {
    -- public class hudDroneController extends inkHUDGameController {
    -- public class hudJohnnyController extends inkHUDGameController {
    -- public class hudMilitechWarningGameController extends inkHUDGameController {
    -- public native class PanzerHUDGameController extends inkHUDGameController {
    -- public class hudRecordingController extends inkHUDGameController {
    -- public class hudTurretController extends inkHUDGameController {
    -- public class OnscreenMessageGameController extends inkHUDGameController {
    -- public class IncomingCallGameController extends inkHUDGameController {
    -- public class PhoneDialerGameController extends inkHUDGameController {
    -- public native class scannerGameController extends inkHUDGameController {
    -- public class scannerDetailsGameController extends inkHUDGameController {
    -- public class WarningMessageGameController extends inkHUDGameController {
    -- public class hudButtonReminderGameController extends inkHUDGameController {
    -- public class InteractionsHubGameController extends inkHUDGameController {
    -- public class interactionWidgetGameController extends inkHUDGameController {
    -- public abstract class InteractionUIBase extends inkHUDGameController {
    -- public class buffListGameController extends inkHUDGameController {
    -- public class healthbarWidgetGameController extends inkHUDGameController {
    -- public class netChargesWidgetGameController extends inkHUDGameController {
    -- public class OxygenbarWidgetGameController extends inkHUDGameController {
    -- public class StaminabarWidgetGameController extends inkHUDGameController {
    -- public class QuestListGameController extends inkHUDGameController {
    -- public class QuestUpdateGameController extends inkHUDGameController {
    -- public class QuestTrackerGameController extends inkHUDGameController {
    -- public class RadialWheelController extends inkHUDGameController {
    -- public class hudCarController extends inkHUDGameController {
    -- public class hudCarRaceController extends inkHUDGameController {
    -- public class vehicleInteriorUIGameController extends inkHUDGameController {
    -- public class vehicleUIGameController extends inkHUDGameController {
    -- public native class BaseVehicleHUDGameController extends inkHUDGameController {
    -- public native class gameuiCrosshairContainerController extends inkHUDGameController {
    -- public class CrosshairGameControllerPersistentDot extends inkHUDGameController {
    -- public class CrouchIndicatorGameController extends inkHUDGameController {
    -- public class weaponIndicatorController extends inkHUDGameController {
    -- public class weaponRosterGameController extends inkHUDGameController {
    -- public class RadialMenuGameController extends inkHUDGameController {
    -- public native class gameuiChatBoxGameController extends inkHUDGameController {
    -- public class NarrationJournalGameController extends inkHUDGameController {
    -- public native class gameuiPlayerListGameController extends inkHUDGameController {
    -- public native class DamageIndicatorGameController extends inkHUDGameController {
    -- public native class StealthIndicatorGameController extends inkHUDGameController {
    -- public class artist_test_area_r extends inkHUDGameController {
    -- public class CarRadioGameController extends inkHUDGameController {
    -- public abstract class GenericHotkeyController extends inkHUDGameController {
    -- public class HotkeysWidgetController extends inkHUDGameController {
    -- public class DpadWheelGameController extends inkHUDGameController {
    -- public class keyboardHintGameController extends inkHUDGameController {
    -- public class BossHealthBarGameController extends inkHUDGameController {
    -- public class CompanionHealthBarGameController extends inkHUDGameController {
    -- public class HUDProgressBarController extends inkHUDGameController {
    -- public class HUDSignalProgressBarController extends inkHUDGameController {
    -- public class BraindanceGameController extends inkHUDGameController {
    -- public class CharacterLevelUpGameController extends inkHUDGameController {
    -- public class CustomQuestNotificationGameController extends inkHUDGameController {
    -- public class LevelUpGameController extends inkHUDGameController {
    -- public class NewAreaGameController extends inkHUDGameController {
    -- public class stealthAlertGameController extends inkHUDGameController {
    -- public class VehicleSummonWidgetGameController extends inkHUDGameController {
    -- public class QuickhacksListGameController extends inkHUDGameController {
    -- public class TimerGameController extends inkHUDGameController {
    -- public class WantedBarGameController extends inkHUDGameController {
    -- public native class inkProjectedHUDGameController extends inkHUDGameController {
    -- public native class BaseVehicleHUDGameController extends inkHUDGameController {
    -- public native class PanzerHUDGameController extends inkHUDGameController {
    -- public native class scannerGameController extends inkHUDGameController {
    -- public native class gameuiCrosshairContainerController extends inkHUDGameController {
    -- public class StealthZonesGameController extends inkHUDGameController {
    -- public class RadialMenuItem extends inkHUDGameController {
    -- public native class gameuiChatBoxGameController extends inkHUDGameController {
    -- public native class gameuiPlayerListGameController extends inkHUDGameController {
    -- public native class DamageIndicatorGameController extends inkHUDGameController {
    -- public native class StealthIndicatorGameController extends inkHUDGameController {
end