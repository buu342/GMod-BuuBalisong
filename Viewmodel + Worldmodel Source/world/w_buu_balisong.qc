// Created by Crowbar 0.19.0.0

$modelname "weapons/w_buu_balisong.mdl"
$model "studio" "w_buu_balisong.smd"

$cdmaterials "models\weapons\buu342\"

$surfaceprop "weapon"
$contents "solid"

$Sequence "idle" {
	"w_buu_balisong.smd"
	activity "ACT_VM_IDLE" 1
}

$collisionmodel "w_buu_balisong.smd"
{
	$mass 8
	$inertia 1
	$damping 0
	$rotdamping 0
}