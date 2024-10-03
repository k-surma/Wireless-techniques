len=100000;
R = randi([0,1],len,1);
BPSK_modulator=comm.PSKModulator(2,0);
modulated_signal=step(BPSK_modulator,R);
scatterplot(modulated_signal);

Pt_mW=40;
Pt_dB=10*log10(Pt_mW);
PL=145;
Pr=Pt_dB-PL;
N=-136;
snr=Pr-N
channel=comm.AWGNChannel("NoiseMethod","Signal to noise ratio (SNR)", "SNR", snr);
rchannel=step(channel, modulated_signal);
scatterplot(rchannel)

BPSK_demodulator=comm.PSKDemodulator(2,0);
demodulated_signal=step(BPSK_demodulator, rchannel);
scatterplot(demodulated_signal);

ber=comm.ErrorRate;
BER=step(ber, R, demodulated_signal)
