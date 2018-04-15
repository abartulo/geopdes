% SP_H1_ERROR: Evaluate the error in H^1 norm.
%
%   [errh1, errl2, errh1s] = sp_h1_error (space, msh, u, uex, graduex)
%
% INPUT:
%
%    space:   object defining the space of discrete functions (see sp_multipatch)
%    msh:     object defining the domain partition and the quadrature rule (see msh_multipatch)
%    u:       vector of dof weights
%    uex:     function handle to evaluate the exact solution
%    graduex: function handle to evaluate the gradient of the exact solution
%
% OUTPUT:
%
%     errh1:  error in H^1 norm
%     errl2:  error in L^2 norm
%     errh1s: error in H^1 seminorm
%
% Copyright (C) 2015 Rafael Vazquez
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.

% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Octave; see the file COPYING.  If not, see
% <http://www.gnu.org/licenses/>.

function [err_stress] = sp_stress_error (space, msh, u, lambda_lame, mu_lame, graduex)
% Graduex is the exact gradient. I compute the exact stress using it.

  if (space.npatch ~= msh.npatch)
    error ('The number of patches does not coincide') 
  end

  for iptc = 1:msh.npatch
    if (isempty (space.dofs_ornt))
      u_ptc = u(space.gnum{iptc});
    else
      u_ptc = u(space.gnum{iptc}) .* space.dofs_ornt{iptc}.';
    end
    [error_stress(iptc)] = ...
        sp_stress_error (space.sp_patch{iptc}, msh.msh_patch{iptc}, u_ptc, lambda_lame, mu_lame, graduex);
  end
  err_stress = sqrt (sum (error_stress .* error_stress));
end
