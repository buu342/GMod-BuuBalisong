$modelname "weapons\c_buu_balisong.mdl"
$model "studio" "c_buu_balisong.smd"

$cdmaterials "models\weapons\buu342\"
$attachment "1" "ValveBiped.Bip01_R_Hand" 0 0 0 rotate -0 -45 -0

$sequence "idle" "anims\idle.smd" {
	"ACT_VM_IDLE" 1
	loop
}

$sequence "draw1" "anims\draw1.smd" {
	"ACT_VM_DRAW" 1
	snap
	{ event 5004 3 "Weapon_BuuBalisong.MoveOpen" }
	{ event 5004 8 "Weapon_BuuBalisong.Move1" }
	{ event 5004 16 "Weapon_BuuBalisong.Move2" }
	{ event 5004 32 "Weapon_BuuBalisong.HandHit" }
	{ event 5004 42 "Weapon_BuuBalisong.Finish" }
}

$sequence "draw2" "anims\draw2.smd" {
	"ACT_VM_DRAW" 1
	snap
	{ event 5004 2 "Weapon_BuuBalisong.MoveOpen" }
	{ event 5004 8 "Weapon_BuuBalisong.Move1" }
	{ event 5004 16 "Weapon_BuuBalisong.Move2" }
	{ event 5004 24 "Weapon_BuuBalisong.HandHit" }
	{ event 5004 38 "Weapon_BuuBalisong.Finish" }
}

$sequence "draw3" "anims\draw3.smd" {
	"ACT_VM_DRAW" 1
	snap
	{ event 5004 2 "Weapon_BuuBalisong.MoveOpen" }
	{ event 5004 5 "Weapon_BuuBalisong.Move1" }
	{ event 5004 12 "Weapon_BuuBalisong.HandHit" }
	{ event 5004 14 "Weapon_BuuBalisong.MoveClose" }
	{ event 5004 23 "Weapon_BuuBalisong.HandHit" }
	{ event 5004 29 "Weapon_BuuBalisong.Move2" }
	{ event 5004 36 "Weapon_BuuBalisong.Finish" }
}

$sequence "draw4" "anims\draw4.smd" {
	"ACT_VM_DRAW" 1
	snap
	{ event 5004 2 "Weapon_BuuBalisong.MoveOpen" }
	{ event 5004 12 "Weapon_BuuBalisong.Move1" }
	{ event 5004 17 "Weapon_BuuBalisong.Move2" }
	{ event 5004 22 "Weapon_BuuBalisong.Finish" }
}

$sequence "draw_fail" "anims\draw_fail.smd" {
	"ACT_VM_DRAW_EMPTY" 1
	snap
	{ event 5004 2 "Weapon_BuuBalisong.MoveOpen" }
	{ event 5004 8 "Weapon_BuuBalisong.Move1" }
	{ event 5004 16 "Weapon_BuuBalisong.Move2" }
	{ event 5004 24 "Weapon_BuuBalisong.HandHit" }
	{ event 5004 28 "Weapon_BuuBalisong.Move2" }
}

$sequence "hithard" "anims\hithard.smd" {
	fps 45
	"ACT_VM_HITCENTER" 1
	snap
}

$sequence "miss1" "anims\miss1.smd" {
	fps 45
	"ACT_VM_MISSCENTER" 1
	snap
}

$sequence "miss2" "anims\miss2.smd" {
	fps 45
	"ACT_VM_MISSCENTER" 1
	snap
}


$bonemerge "ValveBiped.Bip01_Spine4"
$bonemerge "ValveBiped.Bip01_L_Clavicle"
$bonemerge "ValveBiped.Bip01_L_UpperArm"
$bonemerge "ValveBiped.Bip01_L_Forearm"
$bonemerge "ValveBiped.Bip01_L_Hand"
$bonemerge "ValveBiped.Bip01_L_Wrist"
$bonemerge "ValveBiped.Bip01_L_Finger4"
$bonemerge "ValveBiped.Bip01_L_Finger41"
$bonemerge "ValveBiped.Bip01_L_Finger42"
$bonemerge "ValveBiped.Bip01_L_Finger3"
$bonemerge "ValveBiped.Bip01_L_Finger31"
$bonemerge "ValveBiped.Bip01_L_Finger32"
$bonemerge "ValveBiped.Bip01_L_Finger2"
$bonemerge "ValveBiped.Bip01_L_Finger21"
$bonemerge "ValveBiped.Bip01_L_Finger22"
$bonemerge "ValveBiped.Bip01_L_Finger1"
$bonemerge "ValveBiped.Bip01_L_Finger11"
$bonemerge "ValveBiped.Bip01_L_Finger12"
$bonemerge "ValveBiped.Bip01_L_Finger0"
$bonemerge "ValveBiped.Bip01_L_Finger01"
$bonemerge "ValveBiped.Bip01_L_Finger02"
$bonemerge "ValveBiped.Bip01_R_Clavicle"
$bonemerge "ValveBiped.Bip01_R_UpperArm"
$bonemerge "ValveBiped.Bip01_R_Forearm"
$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "ValveBiped.Bip01_R_Wrist"
$bonemerge "ValveBiped.Bip01_R_Finger4"
$bonemerge "ValveBiped.Bip01_R_Finger41"
$bonemerge "ValveBiped.Bip01_R_Finger42"
$bonemerge "ValveBiped.Bip01_R_Finger3"
$bonemerge "ValveBiped.Bip01_R_Finger31"
$bonemerge "ValveBiped.Bip01_R_Finger32"
$bonemerge "ValveBiped.Bip01_R_Finger2"
$bonemerge "ValveBiped.Bip01_R_Finger21"
$bonemerge "ValveBiped.Bip01_R_Finger22"
$bonemerge "ValveBiped.Bip01_R_Finger1"
$bonemerge "ValveBiped.Bip01_R_Finger11"
$bonemerge "ValveBiped.Bip01_R_Finger12"
$bonemerge "ValveBiped.Bip01_R_Finger0"
$bonemerge "ValveBiped.Bip01_R_Finger01"
$bonemerge "ValveBiped.Bip01_R_Finger02"