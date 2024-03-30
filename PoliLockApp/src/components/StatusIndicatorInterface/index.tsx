import React from "react";
import { IonCard, IonCardHeader, IonCardContent, IonIcon, IonText } from "@ionic/react";
import { StatusIndicatorInterface } from "../../types";

const StatusIndicator: React.FC<StatusIndicatorInterface> = ({
  statusToRep,
  status,
  iconSize,
}) => {
  const currentStatus = statusToRep[status];

  return (
    <IonCard>
      <IonCardHeader>
        <IonIcon
          size={iconSize}
          icon={currentStatus.icon}
          color={currentStatus.color}
        />
      </IonCardHeader>
      <IonCardContent>
        <IonText>{currentStatus.name}</IonText>
      </IonCardContent>
    </IonCard>
  );
};

export default StatusIndicator;
