
Q
Command: %s
53*	vivadotcl2 
route_design2default:defaultZ4-113h px? 
?
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7z0202default:defaultZ17-347h px? 
?
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7z0202default:defaultZ17-349h px? 
p
,Running DRC as a precondition to command %s
22*	vivadotcl2 
route_design2default:defaultZ4-22h px? 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px? 
?

?Clock Placer Checks: Poor placement for routing between an IO pin and BUFG. 
Resolution: Poor placement of an IO pin and a BUFG has resulted in the router using a non-dedicated path between the two.  There are several things that could trigger this DRC, each of which can cause unpredictable clock insertion delays that result in poor timing.  This DRC could be caused by any of the following: (a) a clock port was placed on a pin that is not a CCIO-pin (b)the BUFG has not been placed in the same half of the device or SLR as the CCIO-pin (c) a single ended clock has been placed on the N-Side of a differential pair CCIO-pin.
 This is normally an ERROR but the CLOCK_DEDICATED_ROUTE constraint is set to FALSE allowing your design to continue. The use of this override is highly discouraged as it may lead to very poor timing results. It is recommended that this error condition be corrected in the design.

	%s (IBUF.O) is locked to %s
	%s (BUFG.I) is provisionally placed by clockplacer on %s
%s*DRC2L
 "6
SWCLK_IBUF_inst	SWCLK_IBUF_inst2default:default2default:default2B
 ",

IOB_X1Y112

IOB_X1Y1122default:default2default:default2V
 "@
SWCLK_IBUF_BUFG_inst	SWCLK_IBUF_BUFG_inst2default:default2default:default2H
 "2
BUFGCTRL_X0Y2
BUFGCTRL_X0Y22default:default2default:default2;
 #DRC|Implementation|Placement|Clocks2default:default8ZPLCK-12h px? 
b
DRC finished with %s
79*	vivadotcl2(
0 Errors, 1 Warnings2default:defaultZ4-198h px? 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px? 
V

Starting %s Task
103*constraints2
Routing2default:defaultZ18-103h px? 
}
BMultithreading enabled for route_design using a maximum of %s CPUs17*	routeflow2
22default:defaultZ35-254h px? 
p

Phase %s%s
101*constraints2
1 2default:default2#
Build RT Design2default:defaultZ18-101h px? 
C
.Phase 1 Build RT Design | Checksum: 19677bb1d
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:01:03 ; elapsed = 00:00:47 . Memory (MB): peak = 1754.656 ; gain = 17.5202default:defaulth px? 
v

Phase %s%s
101*constraints2
2 2default:default2)
Router Initialization2default:defaultZ18-101h px? 
o

Phase %s%s
101*constraints2
2.1 2default:default2 
Create Timer2default:defaultZ18-101h px? 
B
-Phase 2.1 Create Timer | Checksum: 19677bb1d
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:01:03 ; elapsed = 00:00:48 . Memory (MB): peak = 1777.414 ; gain = 40.2772default:defaulth px? 
{

Phase %s%s
101*constraints2
2.2 2default:default2,
Fix Topology Constraints2default:defaultZ18-101h px? 
N
9Phase 2.2 Fix Topology Constraints | Checksum: 19677bb1d
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:01:04 ; elapsed = 00:00:49 . Memory (MB): peak = 1784.035 ; gain = 46.8982default:defaulth px? 
t

Phase %s%s
101*constraints2
2.3 2default:default2%
Pre Route Cleanup2default:defaultZ18-101h px? 
G
2Phase 2.3 Pre Route Cleanup | Checksum: 19677bb1d
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:01:04 ; elapsed = 00:00:49 . Memory (MB): peak = 1784.035 ; gain = 46.8982default:defaulth px? 
p

Phase %s%s
101*constraints2
2.4 2default:default2!
Update Timing2default:defaultZ18-101h px? 
C
.Phase 2.4 Update Timing | Checksum: 136dcfd94
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:01:27 ; elapsed = 00:01:05 . Memory (MB): peak = 1822.762 ; gain = 85.6252default:defaulth px? 
?
Intermediate Timing Summary %s164*route2L
8| WNS=-9.136 | TNS=-530.036| WHS=-0.462 | THS=-142.445|
2default:defaultZ35-416h px? 
I
4Phase 2 Router Initialization | Checksum: 1db2d51f9
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:01:35 ; elapsed = 00:01:10 . Memory (MB): peak = 1854.594 ; gain = 117.4572default:defaulth px? 
p

Phase %s%s
101*constraints2
3 2default:default2#
Initial Routing2default:defaultZ18-101h px? 
C
.Phase 3 Initial Routing | Checksum: 1e7fbc97c
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:02:21 ; elapsed = 00:01:35 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
s

Phase %s%s
101*constraints2
4 2default:default2&
Rip-up And Reroute2default:defaultZ18-101h px? 
u

Phase %s%s
101*constraints2
4.1 2default:default2&
Global Iteration 02default:defaultZ18-101h px? 
?
Intermediate Timing Summary %s164*route2K
7| WNS=-9.315 | TNS=-604.349| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px? 
G
2Phase 4.1 Global Iteration 0 | Checksum: dd6b071c
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:05:58 ; elapsed = 00:03:47 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
u

Phase %s%s
101*constraints2
4.2 2default:default2&
Global Iteration 12default:defaultZ18-101h px? 
?
Intermediate Timing Summary %s164*route2K
7| WNS=-9.530 | TNS=-579.869| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px? 
H
3Phase 4.2 Global Iteration 1 | Checksum: 177264049
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:26 ; elapsed = 00:04:08 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
F
1Phase 4 Rip-up And Reroute | Checksum: 177264049
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:26 ; elapsed = 00:04:09 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
|

Phase %s%s
101*constraints2
5 2default:default2/
Delay and Skew Optimization2default:defaultZ18-101h px? 
p

Phase %s%s
101*constraints2
5.1 2default:default2!
Delay CleanUp2default:defaultZ18-101h px? 
r

Phase %s%s
101*constraints2
5.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px? 
E
0Phase 5.1.1 Update Timing | Checksum: 13d1c9191
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:30 ; elapsed = 00:04:11 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
?
Intermediate Timing Summary %s164*route2K
7| WNS=-9.315 | TNS=-580.809| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px? 
C
.Phase 5.1 Delay CleanUp | Checksum: 1605553be
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:35 ; elapsed = 00:04:14 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
z

Phase %s%s
101*constraints2
5.2 2default:default2+
Clock Skew Optimization2default:defaultZ18-101h px? 
M
8Phase 5.2 Clock Skew Optimization | Checksum: 1605553be
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:35 ; elapsed = 00:04:14 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
O
:Phase 5 Delay and Skew Optimization | Checksum: 1605553be
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:35 ; elapsed = 00:04:14 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
n

Phase %s%s
101*constraints2
6 2default:default2!
Post Hold Fix2default:defaultZ18-101h px? 
p

Phase %s%s
101*constraints2
6.1 2default:default2!
Hold Fix Iter2default:defaultZ18-101h px? 
r

Phase %s%s
101*constraints2
6.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px? 
E
0Phase 6.1.1 Update Timing | Checksum: 102471668
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:39 ; elapsed = 00:04:17 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
?
Intermediate Timing Summary %s164*route2K
7| WNS=-9.313 | TNS=-575.566| WHS=0.086  | THS=0.000  |
2default:defaultZ35-416h px? 
C
.Phase 6.1 Hold Fix Iter | Checksum: 102471668
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:39 ; elapsed = 00:04:17 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
A
,Phase 6 Post Hold Fix | Checksum: 102471668
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:39 ; elapsed = 00:04:17 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
o

Phase %s%s
101*constraints2
7 2default:default2"
Route finalize2default:defaultZ18-101h px? 
B
-Phase 7 Route finalize | Checksum: 135a45d98
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:40 ; elapsed = 00:04:17 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
v

Phase %s%s
101*constraints2
8 2default:default2)
Verifying routed nets2default:defaultZ18-101h px? 
I
4Phase 8 Verifying routed nets | Checksum: 135a45d98
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:40 ; elapsed = 00:04:18 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
r

Phase %s%s
101*constraints2
9 2default:default2%
Depositing Routes2default:defaultZ18-101h px? 
E
0Phase 9 Depositing Routes | Checksum: 1e4f7eab6
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:46 ; elapsed = 00:04:25 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
t

Phase %s%s
101*constraints2
10 2default:default2&
Post Router Timing2default:defaultZ18-101h px? 
?
Estimated Timing Summary %s
57*route2K
7| WNS=-9.313 | TNS=-575.566| WHS=0.086  | THS=0.000  |
2default:defaultZ35-57h px? 
B
!Router estimated timing not met.
128*routeZ35-328h px? 
G
2Phase 10 Post Router Timing | Checksum: 1e4f7eab6
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:47 ; elapsed = 00:04:25 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
@
Router Completed Successfully
2*	routeflowZ35-16h px? 
?

%s
*constraints2q
]Time (s): cpu = 00:06:47 ; elapsed = 00:04:25 . Memory (MB): peak = 1887.605 ; gain = 150.4692default:defaulth px? 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px? 
?
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
982default:default2
262default:default2
62default:default2
02default:defaultZ4-41h px? 
^
%s completed successfully
29*	vivadotcl2 
route_design2default:defaultZ4-42h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
route_design: 2default:default2
00:06:572default:default2
00:04:302default:default2
1887.6052default:default2
150.4692default:defaultZ17-268h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0192default:default2
1887.6052default:default2
0.0002default:defaultZ17-268h px? 
H
&Writing timing data to binary archive.266*timingZ38-480h px? 
D
Writing placer database...
1603*designutilsZ20-1893h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0282default:default2
1887.6052default:default2
0.0002default:defaultZ17-268h px? 
=
Writing XDEF routing.
211*designutilsZ20-211h px? 
J
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px? 
J
#Writing XDEF routing special nets.
210*designutilsZ20-210h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2)
Write XDEF Complete: 2default:default2
00:00:172default:default2
00:00:082default:default2
1887.6052default:default2
0.0002default:defaultZ17-268h px? 
?
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2k
WC:/Users/84308/Desktop/my_CortexM3_hdmi/vivado/CortexM3.runs/impl_1/CortexM3_routed.dcp2default:defaultZ17-1381h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2&
write_checkpoint: 2default:default2
00:00:192default:default2
00:00:102default:default2
1887.6052default:default2
0.0002default:defaultZ17-268h px? 
?
%s4*runtcl2?
mExecuting : report_drc -file CortexM3_drc_routed.rpt -pb CortexM3_drc_routed.pb -rpx CortexM3_drc_routed.rpx
2default:defaulth px? 
?
Command: %s
53*	vivadotcl2t
`report_drc -file CortexM3_drc_routed.rpt -pb CortexM3_drc_routed.pb -rpx CortexM3_drc_routed.rpx2default:defaultZ4-113h px? 
>
IP Catalog is up to date.1232*coregenZ19-1839h px? 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px? 
?
#The results of DRC are in file %s.
168*coretcl2?
[C:/Users/84308/Desktop/my_CortexM3_hdmi/vivado/CortexM3.runs/impl_1/CortexM3_drc_routed.rpt[C:/Users/84308/Desktop/my_CortexM3_hdmi/vivado/CortexM3.runs/impl_1/CortexM3_drc_routed.rpt2default:default8Z2-168h px? 
\
%s completed successfully
29*	vivadotcl2

report_drc2default:defaultZ4-42h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2 
report_drc: 2default:default2
00:00:192default:default2
00:00:102default:default2
1887.6052default:default2
0.0002default:defaultZ17-268h px? 
?
%s4*runtcl2?
?Executing : report_methodology -file CortexM3_methodology_drc_routed.rpt -pb CortexM3_methodology_drc_routed.pb -rpx CortexM3_methodology_drc_routed.rpx
2default:defaulth px? 
?
Command: %s
53*	vivadotcl2?
?report_methodology -file CortexM3_methodology_drc_routed.rpt -pb CortexM3_methodology_drc_routed.pb -rpx CortexM3_methodology_drc_routed.rpx2default:defaultZ4-113h px? 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px? 
?
>Generated clock %s has no logical paths from master clock %s.
174*timing2H
4u_custom_apb_hdmi/u_img2hdmi/rgb2dvi_m0/U0/SerialClk2default:default2&
clk_out1_video_clk2default:defaultZ38-249h px? 
Y
$Running Methodology with %s threads
74*drc2
22default:defaultZ23-133h px? 
?
2The results of Report Methodology are in file %s.
450*coretcl2?
gC:/Users/84308/Desktop/my_CortexM3_hdmi/vivado/CortexM3.runs/impl_1/CortexM3_methodology_drc_routed.rptgC:/Users/84308/Desktop/my_CortexM3_hdmi/vivado/CortexM3.runs/impl_1/CortexM3_methodology_drc_routed.rpt2default:default8Z2-1520h px? 
d
%s completed successfully
29*	vivadotcl2&
report_methodology2default:defaultZ4-42h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2(
report_methodology: 2default:default2
00:00:362default:default2
00:00:202default:default2
1894.4412default:default2
6.8362default:defaultZ17-268h px? 
?
%s4*runtcl2?
}Executing : report_power -file CortexM3_power_routed.rpt -pb CortexM3_power_summary_routed.pb -rpx CortexM3_power_routed.rpx
2default:defaulth px? 
?
Command: %s
53*	vivadotcl2?
preport_power -file CortexM3_power_routed.rpt -pb CortexM3_power_summary_routed.pb -rpx CortexM3_power_routed.rpx2default:defaultZ4-113h px? 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px? 
?
>Generated clock %s has no logical paths from master clock %s.
174*timing2H
4u_custom_apb_hdmi/u_img2hdmi/rgb2dvi_m0/U0/SerialClk2default:default2&
clk_out1_video_clk2default:defaultZ38-249h px? 
K
,Running Vector-less Activity Propagation...
51*powerZ33-51h px? 
?
>Generated clock %s has no logical paths from master clock %s.
174*timing2H
4u_custom_apb_hdmi/u_img2hdmi/rgb2dvi_m0/U0/SerialClk2default:default2&
clk_out1_video_clk2default:defaultZ38-249h px? 
P
3
Finished Running Vector-less Activity Propagation
1*powerZ33-1h px? 
?
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
1102default:default2
262default:default2
92default:default2
02default:defaultZ4-41h px? 
^
%s completed successfully
29*	vivadotcl2 
report_power2default:defaultZ4-42h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
report_power: 2default:default2
00:00:422default:default2
00:00:252default:default2
1965.9732default:default2
71.5312default:defaultZ17-268h px? 
?
%s4*runtcl2q
]Executing : report_route_status -file CortexM3_route_status.rpt -pb CortexM3_route_status.pb
2default:defaulth px? 
?
%s4*runtcl2?
?Executing : report_timing_summary -max_paths 10 -file CortexM3_timing_summary_routed.rpt -pb CortexM3_timing_summary_routed.pb -rpx CortexM3_timing_summary_routed.rpx -warn_on_violation 
2default:defaulth px? 
r
UpdateTimingParams:%s.
91*timing29
% Speed grade: -2, Delay Type: min_max2default:defaultZ38-91h px? 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
22default:defaultZ38-191h px? 
?
>Generated clock %s has no logical paths from master clock %s.
174*timing2H
4u_custom_apb_hdmi/u_img2hdmi/rgb2dvi_m0/U0/SerialClk2default:default2&
clk_out1_video_clk2default:defaultZ38-249h px? 
?
rThe design failed to meet the timing requirements. Please see the %s report for details on the timing violations.
188*timing2"
timing summary2default:defaultZ38-282h px? 
?
%s4*runtcl2e
QExecuting : report_incremental_reuse -file CortexM3_incremental_reuse_routed.rpt
2default:defaulth px? 
g
BIncremental flow is disabled. No incremental reuse Info to report.423*	vivadotclZ4-1062h px? 
?
%s4*runtcl2e
QExecuting : report_clock_utilization -file CortexM3_clock_utilization_routed.rpt
2default:defaulth px? 
?
%s4*runtcl2?
?Executing : report_bus_skew -warn_on_violation -file CortexM3_bus_skew_routed.rpt -pb CortexM3_bus_skew_routed.pb -rpx CortexM3_bus_skew_routed.rpx
2default:defaulth px? 
r
UpdateTimingParams:%s.
91*timing29
% Speed grade: -2, Delay Type: min_max2default:defaultZ38-91h px? 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
22default:defaultZ38-191h px? 
?
>Generated clock %s has no logical paths from master clock %s.
174*timing2H
4u_custom_apb_hdmi/u_img2hdmi/rgb2dvi_m0/U0/SerialClk2default:default2&
clk_out1_video_clk2default:defaultZ38-249h px? 


End Record