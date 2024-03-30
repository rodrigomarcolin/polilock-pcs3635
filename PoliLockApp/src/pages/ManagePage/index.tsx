import {
  IonContent,
  IonHeader,
  IonPage,
  IonTitle,
  IonToolbar,
} from "@ionic/react";
import { SubmitHandler, FieldValues } from "react-hook-form";
import {  StatusToRepresentationMap } from "../../types";
import ModifyPasswordForm from "./ModifyPasswordForm";

import { closeCircle } from "ionicons/icons";

const ManagePage: React.FC = () => {
  const onSubmit: SubmitHandler<FieldValues> = (data) => {
    console.log("testando submit");
    console.log(data.senha);
  };

  const blockedStatusRep: StatusToRepresentationMap = {
    blocked: {
      color: "danger",
      name: "Bloqueado",
      icon: closeCircle,
    },
  };

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Gerenciar Armário</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent className={"ion-padding ion-margin"} fullscreen>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">Gerenciar Armário</IonTitle>
          </IonToolbar>
        </IonHeader>

        <ModifyPasswordForm/>
      </IonContent>
    </IonPage>
  );
};

export default ManagePage;
