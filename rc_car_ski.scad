$fa = 1;
$fs = 0.4;
J = 0.001;

skiW = 10;  //Width of ski
skiL = 180;  //Length of flat part of ski
skiR = 20;   //Radius of ski tips
skiT = 4;   //Thickness of ski base

mountH = 40;    //Height from top of ski base to center of axle hole
mountW = 10;     //Width of mount
mountD = 15;    //Depth of mount
mountS = 40;    //Side length of triangle to support mount
axleR = 3;      //Radius of axle hole

runnerS = 1.5;    //Size of runner

springholeR = 1;    //Radius of hole to attach spring
    
module ski_base(){
    translate([-0.5*skiL,-0*skiW,0])
    cube([skiL,skiW,skiT]);
}

module ski_tip(){
    difference()
    {
    union(){
        translate([-0.5*skiL,0,skiR])
        rotate([-90,0,0])
        difference(){
            cylinder(skiW,r=skiR);
            translate([0,0,-J])
            cylinder(skiW+2*J,r=(skiR-skiT));
        }
        
        translate([0.5*skiL,0,skiR])
        rotate([-90,0,0])
        difference(){
            cylinder(skiW,r=skiR);
            translate([0,0,-J])
            cylinder(skiW+2*J,r=(skiR-skiT));
        }
    }
    //remove back of cylinder that creates the tip
    translate([-0.5*skiL,-J,0])
    cube([skiL,skiW+2*J,skiR*2]);
    //Height of tip - cut away top of cylinder that creates the tip
    translate([-0.5*skiL*2,-J,1.2*skiR])
    cube([skiL*2,skiW+2*J,skiR*2]);
    translate([-0.5*skiL*2,0.5*(skiW-springholeR),0.9*skiR])
    rotate([0,90,0])
    cylinder(skiL*2,r=springholeR);    
    }
}

module mount(){
    difference()
    {
        translate([-0.5*mountD,0.5*(skiW-mountW),0])
        cube([mountD,mountW,mountH+3*axleR]);
        rotate([-90,0,0])
        translate([0,-mountH,0])
        cylinder(skiW,r=axleR);
    }
}

module mount_support(){
    translate([-0.5*sqrt(mountS^2+mountS^2),0.5*(skiW+mountW),0])
    rotate([90,45,0])
    linear_extrude(mountW)
    polygon([[0,0],[0,mountS],[mountS,mountS]]);
}

module runner(){
    //Runners are triangular to make the ski easier to print on its side
    runnerW = sqrt(runnerS^2+runnerS^2);
    translate([0,0,-0.5*runnerW])
    rotate([45,0,0])
    translate([-0.5*(skiL+0.85*skiR),0,0])
    cube([skiL+0.85*skiR,runnerS,runnerS]);
}

module runners(){
    runnerW = sqrt(runnerS^2+runnerS^2);
    difference()
    {
        union(){
            translate([0,0.5*runnerW,0])
            runner();
            translate([0,0.5*skiW,0])
            runner();
            translate([0,skiW-0.5*runnerW,0])
            runner();
        }
        //Using the ski tip to round off the runners
        translate([-runnerW,0,-2.75*runnerS])
        ski_tip();
        //Using the ski tip to round off the runners
        translate([runnerW,0,-2.75*runnerS])
        ski_tip();
    }
}
ski_base();
ski_tip();
mount();
mount_support();
runners();