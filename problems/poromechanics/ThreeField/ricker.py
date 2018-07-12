
# Ricker Wavelet Plot Generation
import numpy as np
import matplotlib.pyplot as plt

# ------------------------------------------------------------------------------
def moose_ricker(f, factor, shift, t):
  
  return factor*((1.0 - 2.0*(np.pi**2)*(f**2)*( (t + 1/f * np.pi/shift)**2))*np.exp(-1.0*(np.pi**2)*(f**2)*((t + 1/f * np.pi/shift)**2)))

# ------------------------------------------------------------------------------
# Ricker wavelet parameters

factor = 1e6
f = 10.0
shift = -8.0
t = np.linspace(0,0.5,1001)

ricker = moose_ricker(f, factor, shift, t)

# ------------------------------------------------------------------------------
# Plot Wavelet
fig, ax = plt.subplots()
ax.set_xlabel('time, sec')
ax.set_ylabel('Vertical Displacement, m')
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))

plt.plot(t,ricker)
plt.show()
