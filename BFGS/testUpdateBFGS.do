mata:

b = (-.5625 , -.21875)'
s = b-(1,-1)'
y = (-123.5352 , -107.0313)'-(800, -400)' // 
// y = (800, -400)'

H = I(2)


s
y
rho = 1/cross(y,s)
printf("rho = %g\n",rho)


IrhosPy = I(2)-rho*s*y'

updiB = (IrhosPy)*H*(IrhosPy)' + rho*s*s'
 
updiB = (updiB + updiB')/2
// invsym(updiB)

V = H
db = s'
dg = y'
dbdgp   = db * dg'
        dgHdgp  = dg * V * dg'
        bPb     = db * db'
        gPg     = dg * dg'
//         if (abs(dbdgp*dgHdgp) > eps*gPg*bPb) {
                // NOTE: -ml_e0_bfgs- can get slightly different results due
                // to the subtraction
                d = db' / dbdgp - V*dg' / dgHdgp
                V = V - db'*db/dbdgp + dgHdgp*d*d' - (V*dg')*(dg*V')/dgHdgp
                V = (V + V')/2
V
updiB
invsym(V)				

end
