import { IonItem, IonLabel, IonModal, IonList, IonIcon } from "@ionic/react";
import { personCircle } from "ionicons/icons";
import Lottie from "react-lottie";

import "./main.css";

const UnlockModalSuccess = ({
  onDismiss,
}: {
  onDismiss: (data?: string | null | undefined | number, role?: string) => void;
}) => {
  return (
    <IonModal id="example-modal" trigger="open-custom-dialog">
      <div className="wrapper">
        <h1>Dialog header</h1>

        <IonList lines="none">
          <IonItem button={true} detail={false}>
            <IonIcon icon={personCircle}></IonIcon>
            <IonLabel>Item 1</IonLabel>
          </IonItem>
          <IonItem button={true} detail={false}>
            <IonIcon icon={personCircle}></IonIcon>
            <IonLabel>Item 2</IonLabel>
          </IonItem>
          <IonItem button={true} detail={false}>
            <IonIcon icon={personCircle}></IonIcon>
            <IonLabel>Item 3</IonLabel>
          </IonItem>
        </IonList>
      </div>
    </IonModal>
  );
};

export default UnlockModalSuccess;
