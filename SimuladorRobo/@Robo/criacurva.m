function f = criacurva(varargin)

if nargin==0
    hold on
    axis([-1 1 -1 1]);
    grid on;
    terminou=0;
    i=1;
    while ~terminou
        [x, y, but] = ginput(1);
        PD(:,i) = [x;y];
        text(PD(1,i), PD(2,i), num2str(i));
        
        terminou = (but~=1);
        i=i+1;
        axis([-1 1 -1 1]);
    end
    hold off;
else
   PD = varargin{1}; 
end



fx = Robo.sminterp(PD(1,:));
fy = Robo.sminterp(PD(2,:));

f = @(t) [fx(t); fy(t)];

t=0:0.001:1;


grid on;
plot(fx(t),fy(t));
hold on;
plot(PD(1,:),PD(2,:),'ro');
hold off;
grid on;
axis([-1 1 -1 1]);

end