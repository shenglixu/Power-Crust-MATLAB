function [ polesMat, poleRadMat] = FindPoles( verts, cells, points )
    polesMat = zeros(length(cells)*2, 1);
    poleRadMat = zeros(length(cells)*2, 1);
    j = 1;
    for i =1:length(cells)
        thisPoint = points(i,:);
        thisCell = cells{i};
        cellsVertices = verts(thisCell,:); 
        
        %find the furthest voroni vertex
        thisPointMat =  repmat(thisPoint, length(cellsVertices), 1);
        distFromPoint = (cellsVertices - thisPointMat) .^ 2;
        distFromPoint = sum(distFromPoint, 2);
        distFromPoint = sqrt(distFromPoint);
        [~, idx] = max(distFromPoint);
        firstPole = cellsVertices(idx,:);
        firstPoleIdx = thisCell(idx);
        firstPoleMat = repmat(firstPole, length(cellsVertices), 1);
        firstRad = distFromPoint(idx);
        
        %find the second pole
        vectorToFurthestMat = firstPoleMat - thisPointMat;
        vectorToEach = cellsVertices - thisPointMat;
        negativeDot = dot(vectorToFurthestMat, vectorToEach, 2) < 0;
        onlyNegatives = distFromPoint(negativeDot, :);
        [secondRad, idx] = max(onlyNegatives);
        filteredVertices = thisCell(negativeDot);
        secondPoleIdx = filteredVertices(idx);
        
        polesMat(j) = firstPoleIdx;
        poleRadMat(j) = firstRad;
        polesMat(j+1) = secondPoleIdx;
        poleRadMat(j+1) = secondRad;
        j=j+2;
        
        %hold on;
        %plot cell hull
        %hull = convhulln(cellsVertices); 
        %patch('Vertices',cellsVertices,'Faces',hull,'FaceColor','g','FaceAlpha',0.2) 
        %plot this vertex
        %plot3(thisPoint(1), thisPoint(2), thisPoint(3),  'ws--', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');
        %plot poles
        %plot3(firstPole(1), firstPole(2), firstPole(3),  'ws--', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
        %plot3(secondPole(1), secondPole(2), secondPole(3),  'ws--', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
    end

end
