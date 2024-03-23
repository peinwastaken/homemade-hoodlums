-- camera
CreateClientConVar("hoodlum_fov", 110, true, false, "Field of View.", 50, 179) -- but why would you ever use values above 120?
CreateClientConVar("hoodlum_cam_smooth", 6, true, false, "Camera smoothing. Higher values = less smoothing.", 1, 15)

-- head
CreateClientConVar("hoodlum_invishead", 1, true, false, "Makes the head invisible. Changing this to false can and WILL cause anomalous behaviour.", 0, 1)